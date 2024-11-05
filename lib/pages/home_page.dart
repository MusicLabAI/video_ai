import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_ai/api/request.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/models/prompt_model.dart';
import 'package:video_ai/widgets/custom_button.dart';

import '../controllers/main_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final MainController _mainCtr = Get.find<MainController>();
  File? _image;
  final RxBool _isEnable = false.obs;
  late TextEditingController _controller;
  final createCtr = Get.put(CreateController());
  List<PromptModel> _items = [];
  List<PromptModel> _randomItems = [];

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
    ever(_mainCtr.prompt, (value) {
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
      onTap: () => _hideKeyboard(context),
      child: Column(
        children: [
          SizedBox(
            height: 56,
            width: double.infinity,
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                Text(
                  'videoAi'.tr,
                  style: const TextStyle(
                      fontSize: 20,
                      color: UiColors.cDBFFFFFF,
                      fontWeight: FontWeightExt.semiBold),
                ),
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
                              'enterAPromptHere'.tr,
                              style: const TextStyle(
                                  color: UiColors.cBC8EF5,
                                  fontSize: 14,
                                  fontWeight: FontWeightExt.semiBold),
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
                                    color: UiColors.c61FFFFFF),
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
                              Row(
                                children: [
                                  IconTextButton(
                                      icon: Image.asset(
                                        'images/icon/ic_add.png',
                                        width: 16,
                                        height: 16,
                                      ),
                                      text: 'addImage'.tr,
                                      onTap: () {
                                        _pickImage();
                                      }),
                                  if (_image != null)
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _image = null;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            color: UiColors.c1A9CC2FF,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Image(
                                                image: FileImage(_image!),
                                                width: 16,
                                                height: 16,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Image.asset(
                                              'images/icon/ic_delete.png',
                                              width: 16,
                                              height: 16,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconTextButton(
                                      icon: Image.asset(
                                        'images/icon/ic_shuffle.png',
                                        width: 16,
                                        height: 16,
                                      ),
                                      text: 'inspireMe'.tr,
                                      onTap: () {
                                        if (_randomItems.isEmpty) {
                                          return;
                                        }
                                        setState(() {
                                          _controller.text = _randomItems[
                                                      Random().nextInt(
                                                          _randomItems.length)]
                                                  .prompt ??
                                              "";
                                        });
                                      })
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  _getGenerateBtn(context),
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

  Widget _getGenerateBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 28, left: 20, right: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (_isEnable.value) {
            _hideKeyboard(context);
            generate();
          } else {
            Fluttertoast.showToast(msg: 'prompt_empty_tips'.tr);
          }
        },
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: _isEnable.value
                      ? [UiColors.c7631EC, UiColors.cA359EF]
                      : [UiColors.c272931, UiColors.c272931]),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'generate'.tr,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeightExt.semiBold,
                    color: _isEnable.value
                        ? UiColors.cDBFFFFFF
                        : UiColors.c61FFFFFF),
              ),
              const SizedBox(
                width: 4,
              ),
              Image.asset(
                'images/icon/ic_arrow_right.png',
                width: 30,
                height: 30,
                color: _isEnable.value ? Colors.white : null,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _listItem(String item, bool isLast, Function() onTap) {
    return Padding(
      padding: EdgeInsets.only(
          top: 10, left: 20, right: 20, bottom: isLast ? 82 : 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
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
    bool result = await createCtr.aiGenerate(_controller.text, _image);
    if (result) {
      _mainCtr.tabController.index = 1;
      _mainCtr.refreshRecords.value = true;
    }
  }

  void _hideKeyboard(BuildContext context) {
    //FocusScope.of(context).requestFocus(FocusNode())
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
