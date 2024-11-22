import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_ai/api/request.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/controllers/mine_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/models/prompt_model.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';
import 'package:video_ai/pages/settings_page.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/user_info_widget.dart';

import '../controllers/main_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final MainController _mainCtr = Get.find<MainController>();
  final UserController _userCtr = Get.find<UserController>();
  final MineController _mineCtr = Get.find<MineController>();
  File? _image;
  final RxBool _isEnable = false.obs;
  late TextEditingController _controller;
  final createCtr = Get.put(CreateController());
  List<PromptModel> _items = [];
  List<PromptModel> _randomItems = [];
  Worker? _worker;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _mainCtr.prompt.value);
    _controller.addListener(() {
      _isEnable.value = _controller.text.isNotEmpty;
    });
    _worker = ever(_mainCtr.prompt, (value) {
      setState(() {
        _controller.text = value;
        _isEnable.value = _controller.text.isNotEmpty;
      });
    });
    _getRecommendPrompt();
  }

  @override
  void dispose() {
    _controller.dispose();
    _worker?.dispose();
    super.dispose();
  }

  void _getRecommendPrompt() async {
    final data = await Request.getRecommendPrompt();
    _items =
        (data as List).map((record) => PromptModel.fromJson(record)).toList();
    _randomRecommend();
  }

  void _randomRecommend() {
    if (!mounted) {
      return;
    }
    setState(() {
      if (_items.isNotEmpty) {
        if (_items.length > 5) {
          _items.shuffle(Random());
          _randomItems = _items.sublist(0, 5);
        } else {
          _randomItems = _items;
        }
      } else {
        _randomItems = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.hideKeyboard(context),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(left: 16),
            height: 56,
            width: double.infinity,
            child: Row(
              children: [
                const Text(
                  'Video AI',
                  style: TextStyle(
                      fontSize: 20,
                      color: UiColors.cDBFFFFFF,
                      fontWeight: FontWeightExt.semiBold),
                ),
                const Spacer(),
                UserInfoWidget(),
                IconButton(
                    onPressed: () {
                      CommonUtil.hideKeyboard(context);
                      Get.to(() => const SettingsPage());
                    },
                    icon: Image.asset(
                      'images/icon/ic_user.png',
                      width: 24,
                      height: 24,
                    ))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 52,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                              color: UiColors.c42BE8FF7),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'images/icon/ic_video_player.png',
                              width: 76,
                              height: 76,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              'prompt'.tr,
                              style: const TextStyle(
                                  color: UiColors.cBC8EF5,
                                  fontSize: 14,
                                  fontWeight: FontWeightExt.semiBold),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (_controller.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'noPromptEntered'.tr);
                                  return;
                                }
                                setState(() {
                                  _controller.text = "";
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                    color: UiColors.c666949A1,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Image.asset(
                                  'images/icon/ic_clear.png',
                                  width: 14,
                                ),
                              ),
                            ),
                            CustomButton(
                                borderRadius: 8,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 6),
                                bgColor: UiColors.c666949A1,
                                leftIcon: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Image.asset(
                                    'images/icon/ic_shuffle.png',
                                    width: 14,
                                    height: 14,
                                  ),
                                ),
                                text: 'inspireMe'.tr,
                                textSize: 10,
                                textColor: UiColors.cDBFFFFFF,
                                onTap: () {
                                  if (_randomItems.isEmpty) {
                                    return;
                                  }
                                  setState(() {
                                    _controller.text = _randomItems[Random()
                                                .nextInt(_randomItems.length)]
                                            .prompt ??
                                        "";
                                  });
                                }),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 16, right: 8, top: 16, bottom: 16),
                          margin: const EdgeInsets.only(top: 56),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: UiColors.c1B1B1F,
                              border: Border.all(color: UiColors.c30333F)),
                          child: Column(
                            children: [
                              TextField(
                                controller: _controller,
                                onChanged: (str) {
                                  setState(() {
                                    _isEnable.value = str.isNotEmpty;
                                  });
                                },
                                cursorColor: UiColors.c61FFFFFF,
                                maxLines: 6,
                                maxLength: 500,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeightExt.regular,
                                    color: UiColors.cDBFFFFFF),
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeightExt.regular,
                                      color: UiColors.c61FFFFFF),
                                  contentPadding: EdgeInsets.zero,
                                  hintText: 'enterAPromptTips'.tr,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _pickImage(),
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  margin: const EdgeInsets.only(top: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: UiColors.cBC8EF5)),
                                  child: Stack(children: [
                                    if (_image != null)
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          _image = null;
                                        }),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0, top: 2.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Image(
                                                  image: FileImage(_image!),
                                                  width: 34,
                                                  height: 34,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Image.asset(
                                                'images/icon/ic_remove.png',
                                                width: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            _image == null
                                                ? 'images/icon/ic_pick_image.png'
                                                : 'images/icon/ic_reset.png',
                                            width: 16,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            _image == null
                                                ? 'addImage'.tr
                                                : 'replaceImage'.tr,
                                            style: TextStyle(
                                                color: UiColors.cBC8EF5,
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeightExt.medium),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  ..._getGenerateBtn(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/icon/ic_suggestion.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'giveMeSomeInspiration'.tr,
                          style: const TextStyle(
                              fontSize: 14,
                              color: UiColors.cBC8EF5,
                              fontWeight: FontWeightExt.semiBold),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: InkWell(
                            onTap: () {
                              if (_items.isEmpty) {
                                _getRecommendPrompt();
                              } else {
                                _randomRecommend();
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: UiColors.c272931),
                              child: Image.asset(
                                'images/icon/ic_refresh.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ..._randomItems.map((item) {
                    final prompt = item.prompt ?? "";
                    return _listItem(prompt, item == _randomItems.last, () {
                      setState(() {
                        _controller.text = prompt;
                      });
                    });
                  }),
                  //
                  // Expanded(
                  //   child: ListView.builder(
                  //       itemCount: _randomItems.length,
                  //       itemBuilder: (context, index) {
                  //         final prompt = _randomItems[index].prompt ?? "";
                  //         return _listItem(prompt, index == _randomItems.length - 1, () {
                  //           setState(() {
                  //             _controller.text = prompt;
                  //           });
                  //         });
                  //       }),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getGenerateBtn(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8, left: 20, right: 20),
        child: CustomButton(
          onTap: () {
            if (_isEnable.value) {
              CommonUtil.hideKeyboard(context);
              generate();
            } else {
              Fluttertoast.showToast(msg: 'prompt_empty_tips'.tr);
            }
          },
          text: 'generate'.tr,
          textColor: _isEnable.value ? UiColors.cDBFFFFFF : UiColors.c61FFFFFF,
          bgColors: _isEnable.value
              ? [UiColors.c7631EC, UiColors.cA359EF]
              : [UiColors.c272931, UiColors.c272931],
          width: double.infinity,
          height: 46,
          textSize: 16,
          rightIcon: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Image.asset(
              'images/icon/ic_arrow_right.png',
              width: 22,
              color: _isEnable.value ? Colors.white : null,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
        child: Text(
          'generateCost'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(color: UiColors.c99FFFFFF, fontSize: 12),
        ),
      ),
    ];
  }

  Widget _listItem(String item, bool isLast, Function() onTap) {
    return Padding(
      padding: EdgeInsets.only(
          top: 10, left: 20, right: 20, bottom: isLast ? 100 : 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
              color: UiColors.c1B1B1F, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                      fontSize: 12,
                      color: UiColors.c61FFFFFF,
                      fontWeight: FontWeightExt.medium),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Image.asset(
                'images/icon/ic_apply.png',
                width: 24,
                height: 24,
              )
            ],
          ),
        ),
      ),
    );
  }

  void generate() async {
    if (!_userCtr.isLogin.value) {
      _userCtr.showLogin();
      return;
    }
    final userInfo = _userCtr.userInfo.value;
    if ((userInfo.point ?? 0) < 10) {
      if (userInfo.isVip ?? false) {
        Get.to(() => const PointPurchasePage());
      } else {
        Get.to(() => const ProPurchasePage());
      }
      return;
    }
    bool result = await createCtr.aiGenerate(_controller.text, _image);
    if (result) {
      _userCtr.getUserInfo();
      _mainCtr.tabController.index = 1;
      _mineCtr.onRefresh();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
