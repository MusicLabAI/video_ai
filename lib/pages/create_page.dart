import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';
import 'package:video_ai/widgets/credits_rules_widget.dart';

import '../common/common_util.dart';
import '../common/firebase_util.dart';
import '../controllers/create_controller.dart';
import '../models/parameter_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/dialogs.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _controller;
  Worker? _promptWorker;
  final CreateController _createCtr = Get.find<CreateController>();
  final UserController _userCtr = Get.find<UserController>();
  bool isEnable = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _createCtr.prompt.value);
    _promptWorker = ever(_createCtr.prompt, (value) {
      setState(() {
        _controller.text = value;
      });
      updateEnableStatus();
    });
    _promptWorker = ever(_createCtr.imagePath, (value) {
      updateEnableStatus();
    });
    updateEnableStatus();
  }

  void updateEnableStatus() {
    setState(() {
      isEnable = _createCtr.prompt.value.isNotEmpty ||
          (_createCtr.imagePath.value?.isNotEmpty ?? false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _promptWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: GestureDetector(
        onTap: () => CommonUtil.hideKeyboard(context),
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: UiColors.c1B1B1F,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20))),
                child: Column(
                  children: [
                    if (_createCtr.imagePath.value?.isNotEmpty ?? false)
                      ImageWithCloseButton(
                        imagePath: _createCtr.imagePath.value!,
                        onTap: () {
                          _createCtr.imagePath.value = null;
                        },
                      ),
                    TextField(
                      onChanged: (value) {
                        _createCtr.prompt.value = value;
                      },
                      controller: _controller,
                      cursorColor: UiColors.c61FFFFFF,
                      maxLines: _createCtr.imagePath.value?.isNotEmpty ?? false
                          ? 6
                          : 12,
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
                        hintText: 'promptHint'.tr,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                    Row(
                      children: [
                        Obx(() => CustomButton(
                              text: 'costsCreditsValue'
                                  .trArgs(["${_createCtr.getScore()}"]),
                              textSize: 12,
                              textColor: UiColors.cDBFFFFFF,
                              leftIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.asset(
                                  "assets/images/ic_point.png",
                                  width: 20,
                                ),
                              ),
                            )),
                        GestureDetector(
                          onTap: () {
                            CommonUtil.hideKeyboard(context);
                            Get.bottomSheet(
                              const CreditsRulesWidget(),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Image.asset(
                              'assets/images/ic_faq.png',
                              width: 20,
                            ),
                          ),
                        ),
                        const Spacer(),
                        CustomButton(
                          onTap: CommonUtil.debounce(() {
                            generate();
                          }),
                          text: 'generate'.tr,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          textColor:
                              isEnable ? UiColors.c1B1B1F : UiColors.c99FFFFFF,
                          bgColor: isEnable ? Colors.white : UiColors.c23242A,
                          textSize: 14,
                          rightIcon: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Image.asset(
                              'assets/images/ic_upload.png',
                              color: isEnable ? null : UiColors.c99FFFFFF,
                              width: 16,
                            ),
                          ),
                        )
                      ],
                    ),
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
                                    'assets/images/ic_add_image.png',
                                    width: 14,
                                    height: 14,
                                  ),
                                ),
                                text: 'image'.tr,
                                textSize: 10,
                                textColor: UiColors.c99FFFFFF,
                                onTap: () async {
                                  CommonUtil.hideKeyboard(context);
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  if (prefs.getBool("isAgree") ?? false) {
                                    showPickupImageDialog();
                                  } else {
                                    showUploadPolicyDialog();
                                  }
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
                              parameterRx: _createCtr.curResolution,
                              validate: (item) {
                                if (_createCtr.curDuration.value.value > 10 &&
                                    item.value == 1080) {
                                  Fluttertoast.showToast(
                                      msg: 'resolutionNotSupport'.tr,
                                      toastLength: Toast.LENGTH_LONG);
                                  _createCtr.curDuration.value =
                                      _createCtr.durationList.firstWhereOrNull(
                                          (item) => item.value == 10)!;
                                }
                                _createCtr.updateDuration(item.value < 1080);
                                return true;
                              },
                            ),
                            CustomParameterButton(
                              icon: 'assets/images/ic_clock.png',
                              dialogTitle: 'duration'.tr,
                              parameterList: _createCtr.durationList,
                              parameterRx: _createCtr.curDuration,
                              validate: (item) {
                                if (_createCtr.curResolution.value.value ==
                                        1080 &&
                                    item.value > 10) {
                                  Fluttertoast.showToast(
                                      msg: 'durationNotSupport'.tr,
                                      toastLength: Toast.LENGTH_LONG);
                                  return false;
                                }
                                return true;
                              },
                            ),
                            CustomParameterButton(
                                icon: 'assets/images/ic_variations.png',
                                dialogTitle: 'variations'.tr,
                                parameterList: _createCtr.variationsList,
                                parameterRx: _createCtr.curVariations,
                                validate: (item) {
                                  return item.enable;
                                }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> generate() async {
    CommonUtil.hideKeyboard(context);
    String prompt = _createCtr.prompt.value;
    if (!isEnable) {
      Fluttertoast.showToast(msg: 'generateTips'.tr);
      return;
    }
    await _userCtr.getUserInfo();
    if (!_userCtr.isLogin.value) {
      _userCtr.showLogin();
      return;
    }
    final userInfo = _userCtr.userInfo.value;
    if (userInfo.pointValue < _createCtr.getScore()) {
      if (userInfo.isVip ?? false) {
        Get.to(() => const PointPurchasePage());
      } else {
        Get.to(() => const ProPurchasePage());
      }
      return;
    }
    _createCtr.aiGenerate(
        prompt, _createCtr.imagePath.value,
        ratio: _createCtr.curRatio.value.value,
        resolution:
        _createCtr.curResolution.value.value,
        duration: _createCtr.curDuration.value.value,
        num: _createCtr.curVariations.value.value);
  }

  void showPickupImageDialog() {
    FireBaseUtil.logEventPopupView("image_example_popup");
    Get.bottomSheet(ImageSourceDialog(onSourceChecked: (source) async {
      String? path = await CommonUtil.pickUpImage(source);
      if (path != null) {
        _createCtr.imagePath.value = path;
      }
    }));
  }

  void showUploadPolicyDialog() {
    Get.dialog(DialogContainer(
        bgColor: UiColors.c23242A,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Center(
            child: Text(
              textAlign: TextAlign.center,
              'mediaUploadPolicy'.tr,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              'mediaUploadPolicyDesc'.tr,
              style: const TextStyle(color: UiColors.cDBFFFFFF, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              'mediaUploadPolicyDesc1'.tr,
              style: const TextStyle(color: UiColors.c99FFFFFF, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              'mediaUploadPolicyDesc2'.tr,
              style: const TextStyle(color: UiColors.c99FFFFFF, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              'mediaUploadPolicyDesc3'.tr,
              style: const TextStyle(color: UiColors.c99FFFFFF, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              'mediaUploadPolicyDesc4'.tr,
              style: const TextStyle(color: UiColors.c99FFFFFF, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: [
                Expanded(
                    child: CustomButton(
                  onTap: () {
                    Get.back();
                  },
                  width: double.infinity,
                  height: 44,
                  text: 'cancel'.tr,
                  textSize: 14,
                  textColor: Colors.white,
                  bgColor: UiColors.c30333F,
                )),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: CustomButton(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("isAgree", true);
                    Get.back();
                    showPickupImageDialog();
                  },
                  width: double.infinity,
                  height: 44,
                  text: 'agree'.tr,
                  textSize: 14,
                  textColor: UiColors.c1B1B1F,
                  bgColor: Colors.white,
                )),
              ],
            ),
          ),
        ])));
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
      required this.parameterRx,
      this.validate});

  final String icon;
  final String dialogTitle;
  final List<ParameterModel> parameterList;
  final Rx<ParameterModel> parameterRx;
  final bool Function(ParameterModel)? validate;

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
              validate: widget.validate,
              anchorViewKey: anchorKey,
            ),
            barrierColor: Colors.transparent);
        setState(() {
          isPopupShowing = false;
        });
      },
      text: widget.parameterRx.value.showName,
      textSize: 10,
      height: 26,
      textColor: isPopupShowing ? Colors.white : UiColors.c99FFFFFF,
      borderRadius: BorderRadius.circular(8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(right: 10),
      bgColor: UiColors.c23242A,
      leftIcon: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Image.asset(
          widget.icon,
          color: isPopupShowing ? Colors.white : null,
          width: 14,
          height: 14,
        ),
      ),
    );
  }
}

class ImageWithCloseButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const ImageWithCloseButton(
      {super.key, required this.imagePath, required this.onTap});

  @override
  _ImageWithCloseButtonState createState() => _ImageWithCloseButtonState();
}

class _ImageWithCloseButtonState extends State<ImageWithCloseButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      height: 200,
      child: Stack(
        children: [
          // 图片
          Positioned.fill(
            child: Center(
              child: RegExp(r'^https?://').hasMatch(widget.imagePath)
                  ? CachedNetworkImage(
                      imageUrl: widget.imagePath,
                      fit: BoxFit.fitHeight,
                    )
                  : Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.fitHeight,
                    ),
            ),
          ),
          // 关闭按钮
          Positioned(
            top: 0,
            right: 8,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Image.asset(
                "assets/images/ic_close_alpha.png",
                width: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
