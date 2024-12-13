import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/old_create_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/models/parameter_model.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';
import 'package:video_ai/pages/prompt_detail_page.dart';
import 'package:video_ai/pages/settings_page.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/dialogs.dart';
import 'package:video_ai/widgets/loading_widget.dart';
import 'package:video_ai/widgets/prompt_list_view.dart';
import 'package:video_ai/widgets/user_info_widget.dart';

import '../controllers/main_controller.dart';

class OldCreatePage extends StatefulWidget {
  const OldCreatePage({super.key});

  @override
  State<OldCreatePage> createState() => _OldCreatePageState();
}

class _OldCreatePageState extends State<OldCreatePage>
    with AutomaticKeepAliveClientMixin {
  final MainController _mainCtr = Get.find<MainController>();
  final UserController _userCtr = Get.find<UserController>();
  final OldCreateController _createCtr = Get.find<OldCreateController>();
  late TextEditingController _controller;
  Worker? _promptWorker;
  Worker? _scrollWorker;

  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(
      0, // 滚动到顶部的位置
      duration: const Duration(milliseconds: 100), // 动画持续时间
      curve: Curves.easeInOut, // 动画曲线
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    String buttonName = (_createCtr.imagePath.isNotEmpty == true)
        ? 'change_image_button'
        : 'add_image_button';
    FireBaseUtil.logEventButtonClick(PageName.createPage, buttonName);
    String? path = await CommonUtil.pickUpImage(source);
    if (path != null) {
      _createCtr.imagePath.value = path;
    }
  }

  bool _isEnable() {
    if (_createCtr.curTabIndex.value != 0) {
      return (_controller.text.isNotEmpty ||
              _createCtr.curEffects.value != null) &&
          _createCtr.imagePath.isNotEmpty == true;
    } else {
      return _controller.text.isNotEmpty;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _createCtr.prompt.value);
    _promptWorker = ever(_createCtr.prompt, (value) {
      setState(() {
        _controller.text = value;
      });
    });
    _scrollWorker = ever(_createCtr.scrollToTop, (value) {
      if (value) {
        _scrollToTop();
        _createCtr.scrollToTop.value = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _promptWorker?.dispose();
    _scrollWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        bottom: false,
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
                          'assets/images/ic_user.png',
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
                              Obx(
                                () => PromptListView(
                                  dataList: _createCtr.promptItems.value,
                                  paddingTop: 16,
                                  onItemClick: (model) {
                                    Get.to(() => PromptDetailPage(
                                          dataList:
                                              _createCtr.promptItems.value,
                                          curEffectsModel: model,
                                        ));
                                  },
                                  onClick: (model) {
                                    FireBaseUtil.logEventButtonClick(
                                        PageName.createPage,
                                        "createPage_example_try_button");
                                    _createCtr.prompt.value =
                                        model.description ?? "";
                                    _createCtr.curTabIndex.value = 0;
                                    _createCtr.scrollToTop.value = true;
                                  },
                                ),
                              )
                            ]),
                      )))
            ])));
  }

  void clearImage() {
    _createCtr.imagePath.value = '';
    FireBaseUtil.logEventButtonClick(
        PageName.createPage, 'delete_image_button');
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
                },
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                bgColor: _createCtr.curTabIndex.value == 0
                    ? UiColors.c523663
                    : UiColors.c1B1B1F,
                text: 'textToVideo'.tr,
                textColor: _createCtr.curTabIndex.value == 0
                    ? UiColors.cE18FF8
                    : UiColors.c61FFFFFF,
                textSize: 12,
                leftIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    _createCtr.curTabIndex.value == 0
                        ? 'assets/images/ic_video_selected.png'
                        : 'assets/images/ic_video_unselected.png',
                    width: 32,
                  ),
                ),
              )),
              Expanded(
                  child: CustomButton(
                onTap: () {
                  _createCtr.curTabIndex.value = 1;
                },
                height: 44,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                bgColor: _createCtr.curTabIndex.value != 0
                    ? UiColors.c4A3663
                    : UiColors.c1B1B1F,
                text: 'imageToVideo'.tr,
                textColor: _createCtr.curTabIndex.value != 0
                    ? UiColors.cBC8EF5
                    : UiColors.c61FFFFFF,
                textSize: 12,
                leftIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    _createCtr.curTabIndex.value != 0
                        ? 'assets/images/ic_image_selected.png'
                        : 'assets/images/ic_image_unselected.png',
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
                border: Border.all(
                    color: _createCtr.curTabIndex.value == 0
                        ? UiColors.c523663
                        : UiColors.c4A3663,
                    width: 2)),
            child: Column(
              children: [
                if (_createCtr.curTabIndex.value == 1)
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
                                      'assets/images/img_upload_default.png',
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
                                'assets/images/ic_remove.png',
                                width: 16,
                              ),
                            ),
                          ),
                        Positioned(
                            right: 12,
                            top: 0,
                            bottom: 0,
                            child: CustomButton(
                              onTap: () {
                                FireBaseUtil.logEventPopupView(
                                    "image_example_popup");
                                Get.bottomSheet(ImageSourceDialog(
                                    onSourceChecked: (source) {
                                  _pickImage(source);
                                }));
                              },
                              text: _createCtr.imagePath.isNotEmpty == true
                                  ? 'replaceImage'.tr
                                  : 'addImage'.tr,
                              textColor: UiColors.cBC8EF5,
                              textSize: 12,
                              rightIcon: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Image.asset(
                                  _createCtr.imagePath.isNotEmpty == true
                                      ? 'assets/images/ic_reset.png'
                                      : "assets/images/ic_add_rect.png",
                                  width: 20,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                TextField(
                  controller: _controller,
                  cursorColor: UiColors.c61FFFFFF,
                  maxLines: 6,
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
                Row(
                  children: [
                    if (_createCtr.curTabIndex.value != 0 &&
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
                                  ? 'assets/images/ic_effects_selected.png'
                                  : 'assets/images/ic_effects_unselected.png',
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
                                      'assets/images/ic_close_little.png',
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
                              Get.dialog(const LoadingWidget(),
                                  barrierDismissible: false);
                              await _createCtr.getEffectsTags();
                              Get.back();
                            }
                            await Get.bottomSheet(const EffectDialog());
                          }),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: GestureDetector(
                        onTap: () {
                          if (_controller.text.isEmpty) {
                            Fluttertoast.showToast(msg: 'noPromptEntered'.tr);
                            return;
                          }
                          _createCtr.prompt.value = "";
                          FireBaseUtil.logEventButtonClick(
                              PageName.createPage, 'clean_button');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: UiColors.c23242A,
                              borderRadius: BorderRadius.circular(8)),
                          child: Image.asset(
                            'assets/images/ic_clear.png',
                            width: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_createCtr.curTabIndex.value == 0)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomButton(
                              height: 26,
                              margin: const EdgeInsets.only(right: 10),
                              borderRadius: BorderRadius.circular(8),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              bgColor: UiColors.c23242A,
                              leftIcon: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Image.asset(
                                  'assets/images/ic_shuffle.png',
                                  width: 14,
                                  height: 14,
                                ),
                              ),
                              text: 'inspireMe'.tr,
                              textSize: 10,
                              textColor: UiColors.c99FFFFFF,
                              onTap: () async {
                                if (_createCtr.promptItems.isEmpty) {
                                  await _createCtr.getRecommendPrompt();
                                }
                                final items = _createCtr.promptItems.value;
                                if (items.isNotEmpty) {
                                  _createCtr.prompt.value =
                                      items[Random().nextInt(items.length)]
                                              .description ??
                                          "";
                                }
                                FireBaseUtil.logEventButtonClick(
                                    PageName.createPage, 'insprire_button');
                              }),
                          CustomParameterButton(
                              icon: 'assets/images/ic_ratio.png',
                              dialogTitle: 'aspectRatio'.tr,
                              parameterList: _createCtr.ratioList,
                              parameterRx: _createCtr.curRatio),
                          CustomParameterButton(
                              icon: 'assets/images/ic_resolution.png',
                              dialogTitle: 'resolution'.tr,
                              parameterList: _createCtr.resolutionList,
                              parameterRx: _createCtr.curResolution),
                          CustomParameterButton(
                              icon: 'assets/images/ic_clock.png',
                              dialogTitle: 'duration'.tr,
                              parameterList: _createCtr.durationList,
                              parameterRx: _createCtr.curDuration),
                        ],
                      ),
                    ),
                  )
              ],
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
          FireBaseUtil.logEventButtonClick(
              PageName.createPage, "createPage_generate_button");
          if (_isEnable()) {
            CommonUtil.hideKeyboard(context);
            generate();
          } else {
            Fluttertoast.showToast(
                msg: _createCtr.curTabIndex.value != 0
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
          child: Obx(() => Text(
            'generateCost'.trArgs(["${_createCtr.getScore()}"]),
            textAlign: TextAlign.center,
            style: const TextStyle(color: UiColors.c99FFFFFF, fontSize: 12),
          ),)
        ),
      ),
    ];
  }

  void generate() async {
    if (!_userCtr.isLogin.value) {
      _userCtr.showLogin();
      return;
    }
    await _userCtr.getUserInfo();
    final userInfo = _userCtr.userInfo.value;
    if ((userInfo.point ?? 0) < _createCtr.getScore()) {
      if (userInfo.isVip ?? false) {
        Get.to(() => const PointPurchasePage());
        FireBaseUtil.logEventButtonClick(
            PageName.createPage, 'global_credits_button');
      } else {
        Get.to(() => const ProPurchasePage());
        FireBaseUtil.logEventButtonClick(
            PageName.createPage, 'global_pro_button');
      }
      return;
    }
    String createType =
        (_createCtr.curTabIndex.value == 0) ? 'TextToVideo' : 'ImageToVideo';
    String effect = _createCtr.curEffects.value?.tag ?? '';
    FireBaseUtil.logEvent(EventName.requestCreation, parameters: {
      'createType': createType,
      'effect': effect,
      'pageName': PageName.createPage
    });
    bool isTextToVideo = _createCtr.curTabIndex.value == 0;
    await _createCtr.aiGenerate(
        _controller.text,
        isTextToVideo ? "" : _createCtr.imagePath.value,
        isTextToVideo ? null : _createCtr.curEffects.value?.id,
        ratio: isTextToVideo ? _createCtr.curRatio.value.value : null,
        resolution: isTextToVideo ? _createCtr.curResolution.value.value : null,
        duration: isTextToVideo ? _createCtr.curDuration.value.value : null);
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomParameterButton extends StatefulWidget {
  const CustomParameterButton(
      {super.key,
      required this.icon,
      required this.dialogTitle,
      required this.parameterList,
      required this.parameterRx});

  final String icon;
  final String dialogTitle;
  final List<ParameterModel> parameterList;
  final Rx<ParameterModel> parameterRx;

  @override
  State<CustomParameterButton> createState() => _CustomParameterButtonState();
}

class _CustomParameterButtonState extends State<CustomParameterButton> {
  bool isPopupShowing = false;
  final GlobalKey anchorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      key: anchorKey,
      onTap: () async {
        CommonUtil.hideKeyboard(context);
        setState(() {
          isPopupShowing = true;
        });
        await Get.dialog(
            ParameterDialog(
              title: widget.dialogTitle,
              list: widget.parameterList,
              parameterRx: widget.parameterRx,
              anchorViewKey: anchorKey,
            ),
            barrierColor: Colors.transparent);
        setState(() {
          isPopupShowing = false;
        });
      },
      text: widget.parameterRx.value.name,
      textSize: 10,
      height: 26,
      textColor: isPopupShowing ? UiColors.cBC8EF5 : UiColors.c99FFFFFF,
      borderRadius: BorderRadius.circular(8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(right: 10),
      bgColor: UiColors.c23242A,
      leftIcon: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Image.asset(
          widget.icon,
          color: isPopupShowing ? UiColors.cBC8EF5 : null,
          width: 14,
          height: 14,
        ),
      ),
    );
  }
}
