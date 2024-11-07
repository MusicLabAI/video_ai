import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/request.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/mine_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/dialogs.dart';
import 'package:video_ai/widgets/loading_dialog.dart';
import 'package:video_ai/widgets/login_widget.dart';

import '../common/common_util.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _userCtr = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _userCtr.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('images/icon/ic_back.png'),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: UiColors.c42BE8FF7,
                    borderRadius: BorderRadius.circular(16)),
                child: Obx(
                  () => Column(children: [
                    if (_userCtr.isLogin.value)
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    UiColors.c7631EC,
                                    UiColors.cA359EF
                                  ]),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                'id'.tr,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: UiColors.cDBFFFFFF,
                                    fontWeight: FontWeightExt.bold),
                              ),
                            ),
                            if (_userCtr.userInfo.value.userId != null)
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${_userCtr.userInfo.value.userId}",
                                    style: const TextStyle(
                                        fontWeight: FontWeightExt.semiBold,
                                        color: UiColors.cBC8EF5,
                                        fontSize: 10),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text:
                                                "${_userCtr.userInfo.value.userId}"));
                                        Fluttertoast.showToast(
                                            msg: 'copySucceed'.tr);
                                      },
                                      icon: Image.asset(
                                        "images/icon/ic_copy.png",
                                        width: 16,
                                        height: 16,
                                      ))
                                ],
                              )
                          ],
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                          color: UiColors.c1B1B1F,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          _SettingsItem(
                              iconPath: 'images/icon/ic_group.png',
                              item: GetPlatform.isAndroid
                                  ? 'termsOfUse'.tr
                                  : 'eula'.tr,
                              onTap: () {
                                CommonUtil.startUrl(GetPlatform.isAndroid
                                    ? GlobalData.termsOfUseUrl
                                    : GlobalData.eulaUrl);
                              }),
                          _SettingsItem(
                              iconPath: 'images/icon/ic_privacy.png',
                              item: 'privacyPolicy'.tr,
                              onTap: () {
                                CommonUtil.startUrl(
                                    GlobalData.privacyNoticeUrl);
                              }),
                          if (_userCtr.isLogin.value)
                            _SettingsItem(
                                iconPath: 'images/icon/ic_delete_account.png',
                                item: 'deleteAccount'.tr,
                                onTap: () {
                                  showDeleteAccountDialog();
                                })
                        ],
                      ),
                    )
                  ]),
                )),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Obx(() => _userCtr.isLogin.value
                  ? CustomButton(
                      height: 46,
                      text: 'logOut'.tr,
                      textColor: UiColors.c61FFFFFF,
                      bgColor: UiColors.c282F3C,
                      onTap: () {
                        Get.dialog(
                          CustomDialog(
                            title: 'logOut'.tr,
                            icon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Image.asset(
                                'images/icon/img_log_out.png',
                                width: 70,
                              ),
                            ),
                            confirmText: 'logOut'.tr,
                            cancelText: 'cancel'.tr,
                            subText: 'logOutTips'.tr,
                            onConfirm: () async {
                              await _userCtr.logout();
                              Get.back();
                            },
                          ),
                        );
                      },
                    )
                  : CustomButton(
                      text: 'logIn'.tr,
                      textColor: UiColors.cDBFFFFFF,
                      bgColors: const [UiColors.c7631EC, UiColors.cA359EF],
                      onTap: () {
                        _userCtr.showLogin();
                      },
                    )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Text(
                "${'version'.tr}:${GlobalData.versionName}",
                style: TextStyle(
                    color: UiColors.c61FFFFFF,
                    fontSize: 14,
                    fontWeight: FontWeightExt.medium),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteAccountDialog() {
    Get.dialog(CustomDialog(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Image.asset(
          'images/icon/ic_warn.png',
          width: 70,
          height: 70,
        ),
      ),
      title: 'confirmDeletion'.tr,
      confirmText: 'delete'.tr,
      cancelText: 'cancel'.tr,
      subText: 'deleteAccountTips'.tr,
      onConfirm: () async {
        Get.back();
        Get.dialog(const LoadingDialog());
        if (GetPlatform.isAndroid) {
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              Fluttertoast.showToast(msg: 'deleteAccountFailed'.tr);
              return;
            }
            await user.delete();
          } on FirebaseAuthException {
            Fluttertoast.showToast(msg: 'deleteAccountFailed'.tr);
            Get.back();
            rethrow;
          }
        }
        await Request.userDelete();
        await _userCtr.logout();
        Get.back();
      },
    ));
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem(
      {super.key,
      required this.iconPath,
      required this.item,
      required this.onTap});

  final String iconPath;
  final String item;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: SizedBox(
          height: 70,
          width: double.infinity,
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Image.asset(
                iconPath,
                width: 24,
                height: 24,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                item,
                style: TextStyle(
                    fontSize: 16,
                    color: UiColors.c99FFFFFF,
                    fontWeight: FontWeightExt.medium),
              ),
              const Spacer(),
              Image.asset(
                'images/icon/ic_right.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ));
  }
}
