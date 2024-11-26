import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/controllers/mine_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';
import 'package:video_ai/pages/settings_page.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/dialogs.dart';
import 'package:video_ai/widgets/loading_dialog.dart';
import 'package:video_ai/widgets/user_info_widget.dart';

import '../controllers/main_controller.dart';
import '../widgets/effects_widget.dart';

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
  final CreateController _createCtr = Get.find<CreateController>();
  final RxBool _isEnable = false.obs;
  late TextEditingController _controller;
  Worker? _worker;

  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(
      0, // 滚动到顶部的位置
      duration: const Duration(milliseconds: 100), // 动画持续时间
      curve: Curves.easeInOut, // 动画曲线
    );
  }

  Future<void> _pickImage() async {
    String buttonName = (_createCtr.imagePath.isNotEmpty == true)
        ? 'change_image_button'
        : 'add_image_button';
    FireBaseUtil.logEventButtonClick(PageName.createPage, buttonName);
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        String ext = extension(pickedFile.path);
        if (ext == ".gif") {
          Fluttertoast.showToast(msg: 'unsupportedImageFormat'.tr);
          return;
        }
        _createCtr.imagePath.value = pickedFile.path;
        updateGenerateBtnStatus();
      }
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        Get.dialog(getRequestPermissionDialog('photoLibraryRequestText'.tr));
      } else {
        Get.log('PlatformException: $e', isError: true);
      }
    } catch (e) {
      Get.log('Error picking image: $e', isError: true);
    }
  }

  void updateGenerateBtnStatus() {
    setState(() {
      if (_createCtr.curTabIndex.value == 0) {
        _isEnable.value = (_controller.text.isNotEmpty ||
                _createCtr.curEffects.value != null) &&
            _createCtr.imagePath.isNotEmpty == true;
      } else {
        _isEnable.value = _controller.text.isNotEmpty;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _createCtr.prompt.value);
    _controller.addListener(() {
      updateGenerateBtnStatus();
    });
    _worker = ever(_createCtr.prompt, (value) {
      setState(() {
        _controller.text = value;
        updateGenerateBtnStatus();
      });
    });
    ever(_createCtr.curEffects, (value) {
      _scrollToTop();
      updateGenerateBtnStatus();
    });
    ever(_createCtr.curTabIndex, (value) {
      updateGenerateBtnStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _worker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () => CommonUtil.hideKeyboard(context),
        child: Column(children: [
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
                      FireBaseUtil.logEventButtonClick(
                          PageName.createPage, 'mine_button');
                    },
                    icon: Image.asset(
                      'images/icon/ic_user.png',
                      width: 24,
                      height: 24,
                    )),
              ],
            ),
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _topView(context),
                          ..._getGenerateBtn(context),
                          _bottomView(),
                          const SizedBox(
                            height: 10,
                          )
                        ]),
                  )))
        ]))
      );
  }

  Widget _bottomView() {
    return Obx(
      () {
        if (_mainCtr.isCreationLayoutSwitch.value) {
          // 提示词布局
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _inspireLabel(),
              ..._createCtr.randomItems.value.map(
                (item) {
                  final prompt = item.prompt ?? "";
                  return _inspiresItem(
                    prompt,
                    false,
                    () {
                      setState(() {
                        _controller.text = prompt;
                      });
                    },
                  );
                },
              ), // 确保 map 的结果转换为列表
            ],
          );
        } else {
          // 特效图布局
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomButton(
                margin: const EdgeInsets.symmetric(vertical: 16),
                text: 'imageMagic'.tr,
                textColor: UiColors.cBC8EF5,
                textSize: 14,
                leftIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'images/icon/ic_effects_selected.png',
                    width: 20,
                  ),
                ),
              ),
              GridView.builder(
                itemCount: _createCtr.effectsList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 154 / 212,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return EffectsWidget(
                    model: _createCtr.effectsList[index],
                    onTap: (model) {
                      _createCtr.selectEffects(model);
                    },
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

  void clearImage() {
    _createCtr.imagePath.value = '';
    updateGenerateBtnStatus();
    FireBaseUtil.logEventButtonClick(PageName.createPage, 'delete_image_button');
  }

  Widget _topView(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                height: 44,
                onTap: () {
                  _createCtr.curTabIndex.value = 0;
                  updateGenerateBtnStatus();
                },
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                bgColor: _createCtr.curTabIndex.value == 0
                    ? UiColors.c4A3663
                    : UiColors.c1B1B1F,
                text: 'imageToVideo'.tr,
                textColor: _createCtr.curTabIndex.value == 0
                    ? UiColors.cE18FF8
                    : UiColors.c61FFFFFF,
                textSize: 12,
                leftIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    _createCtr.curTabIndex.value == 0
                        ? 'images/icon/ic_image_selected.png'
                        : 'images/icon/ic_image_unselected.png',
                    width: 32,
                  ),
                ),
              )),
              Expanded(
                  child: CustomButton(
                onTap: () {
                  _createCtr.curTabIndex.value = 1;
                  updateGenerateBtnStatus();
                },
                height: 44,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                bgColor: _createCtr.curTabIndex.value != 0
                    ? UiColors.c4A3663
                    : UiColors.c1B1B1F,
                text: 'textToVideo'.tr,
                textColor: _createCtr.curTabIndex.value != 0
                    ? UiColors.cE18FF8
                    : UiColors.c61FFFFFF,
                textSize: 12,
                leftIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    _createCtr.curTabIndex.value != 0
                        ? 'images/icon/ic_video_selected.png'
                        : 'images/icon/ic_video_unselected.png',
                    width: 32,
                  ),
                ),
              )),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: UiColors.c1B1B1F,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
                border: Border.all(color: UiColors.c4A3663, width: 2)),
            child: Column(
              children: [
                if (_createCtr.curTabIndex.value == 0)
                  Container(
                    height: 52,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: UiColors.c383142,
                        borderRadius: BorderRadius.circular(8)),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 8,
                          top: 8,
                          bottom: 8,
                          child: GestureDetector(
                            onTap: () {
                              clearImage();
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _createCtr.imagePath.isNotEmpty == true
                                  ? RegExp(r'^https?://')
                                          .hasMatch(_createCtr.imagePath.value!)
                                      ? CachedNetworkImage(
                                          imageUrl: _createCtr.imagePath.value!,
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.cover,
                                        )
                                      : Image(
                                          image: FileImage(File(
                                              _createCtr.imagePath.value!)),
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.cover,
                                        )
                                  : Image.asset(
                                      'images/icon/img_upload_default.png',
                                      width: 36,
                                    ),
                            ),
                          ),
                        ),
                        if (_createCtr.imagePath.isNotEmpty == true)
                          Positioned(
                            left: 36,
                            bottom: 8,
                            child: GestureDetector(
                              onTap: () {
                                clearImage();
                              },
                              child: Image.asset(
                                'images/icon/ic_remove.png',
                                width: 16,
                              ),
                            ),
                          ),
                        Positioned(
                            right: 12,
                            top: 0,
                            bottom: 0,
                            child: CustomButton(
                              onTap: _pickImage,
                              text: _createCtr.imagePath.isNotEmpty == true
                                  ? 'replaceImage'.tr
                                  : 'addImage'.tr,
                              textColor: UiColors.cBC8EF5,
                              textSize: 12,
                              rightIcon: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Image.asset(
                                  _createCtr.imagePath.isNotEmpty == true
                                      ? 'images/icon/ic_reset.png'
                                      : "images/icon/ic_add_rect.png",
                                  width: 20,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                TextField(
                  controller: _controller,
                  onChanged: (str) {
                    setState(() {
                      updateGenerateBtnStatus();
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
                    counterStyle: const TextStyle(
                        fontSize: 10, color: UiColors.c61FFFFFF),
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
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    CustomButton(
                        height: 26,
                        borderRadius: BorderRadius.circular(8),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
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
                        onTap: () async {
                          if (_createCtr.items.isEmpty) {
                            await _createCtr.getRecommendPrompt();
                          }
                          final items = _createCtr.items.value;
                          if (items.isNotEmpty) {
                            setState(() {
                              _controller.text =
                                  items[Random().nextInt(items.length)]
                                          .prompt ??
                                      "";
                            });
                          }
                          FireBaseUtil.logEventButtonClick(
                              PageName.createPage, 'insprire_button');
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    if (_createCtr.curTabIndex.value == 0 &&
                        !_mainCtr.isCreationLayoutSwitch.value)
                      CustomButton(
                          height: 26,
                          borderRadius: BorderRadius.circular(8),
                          contentPadding: EdgeInsets.only(
                              left: 8,
                              right:
                                  _createCtr.curEffects.value == null ? 8 : 4),
                          bgColor: UiColors.c666949A1,
                          leftIcon: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Image.asset(
                              _createCtr.curEffects.value != null
                                  ? 'images/icon/ic_effects_selected.png'
                                  : 'images/icon/ic_effects_unselected.png',
                              width: 14,
                              height: 14,
                            ),
                          ),
                          rightIcon: _createCtr.curEffects.value != null
                              ? GestureDetector(
                                  onTap: () {
                                    _createCtr.curEffects.value = null;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      'images/icon/ic_close_little.png',
                                      width: 14,
                                    ),
                                  ),
                                )
                              : null,
                          text: _createCtr.curEffects.value != null
                              ? _createCtr.curEffects.value!.tag ?? ""
                              : 'effect'.tr,
                          textSize: 10,
                          textColor: _createCtr.curEffects.value != null
                              ? UiColors.cBC8EF5
                              : UiColors.cDBFFFFFF,
                          onTap: () async {
                            if (_createCtr.effectsList.isEmpty) {
                              Get.dialog(const LoadingDialog());
                              await _createCtr.getEffectsTags();
                              Get.back();
                            }
                            await Get.bottomSheet(const EffectDialog());
                          }),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (_controller.text.isEmpty) {
                          Fluttertoast.showToast(msg: 'noPromptEntered'.tr);
                          return;
                        }
                        setState(() {
                          _controller.text = "";
                        });
                        FireBaseUtil.logEventButtonClick(
                            PageName.createPage, 'clean_button');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: UiColors.c666949A1,
                            borderRadius: BorderRadius.circular(8)),
                        child: Image.asset(
                          'images/icon/ic_clear.png',
                          width: 14,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _inspireLabel() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
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
          InkWell(
            onTap: () {
              if (_createCtr.items.isEmpty) {
                _createCtr.getRecommendPrompt();
              } else {
                _createCtr.randomRecommend();
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
          )
        ],
      ),
    );
  }

  List<Widget> _getGenerateBtn(BuildContext context) {
    return [
      CustomButton(
        margin: const EdgeInsets.only(top: 24),
        onTap: () {
          if (_isEnable.value) {
            CommonUtil.hideKeyboard(context);
            generate();
          } else {
            Fluttertoast.showToast(
                msg: _createCtr.curTabIndex.value == 0
                    ? 'imageEmptyTips'.tr
                    : 'promptEmptyTips'.tr);
          }
        },
        text: 'generate'.tr,
        textColor: UiColors.cDBFFFFFF,
        bgColors: const [UiColors.c7631EC, UiColors.cA359EF],
        width: double.infinity,
        height: 46,
        textSize: 16,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
        child: Center(
          child: Text(
            'generateCost'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: UiColors.c99FFFFFF, fontSize: 12),
          ),
        ),
      ),
    ];
  }

  Widget _inspiresItem(String item, bool isLast, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
        FireBaseUtil.logEventButtonClick(
            PageName.createPage, 'global_credits_button');
      } else {
        Get.to(() => const ProPurchasePage());
        FireBaseUtil.logEventButtonClick(PageName.createPage, 'global_pro_button');
      }
      return;
    }
    String createType =
        (_createCtr.curTabIndex.value != 0) ? 'TextToVideo' : 'ImageToVideo';
    String effect = _createCtr.curEffects.value?.tag ?? '';
    FireBaseUtil.logEvent(EventName.requestCreation,
        parameters: {'createType': createType, 'effect': effect});
    bool result = await _createCtr.aiGenerate(
        _controller.text,
        _createCtr.curTabIndex.value == 0 ? _createCtr.imagePath.value : "",
        _createCtr.curTabIndex.value == 0
            ? _createCtr.curEffects.value?.id
            : null);
    if (result) {
      _userCtr.getUserInfo();
      _mainCtr.tabController.index = 2;
      _mineCtr.onRefresh();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
