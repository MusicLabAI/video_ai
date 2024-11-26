import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/request.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/point_record_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/dialogs.dart';
import 'package:video_ai/widgets/loading_dialog.dart';

import '../common/common_util.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _userCtr = Get.find<UserController>();
  bool isSecond = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userCtr.getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => {
        if (!didPop) {back.call()}
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Image.asset('images/icon/ic_back.png'),
            onPressed: back,
          ),
        ),
        body: SafeArea(
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  if (!_userCtr.isLogin.value && !isSecond) _noLoginView(),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_userCtr.isLogin.value && !isSecond)
                          _userInfoView(),
                        Container(
                          decoration: BoxDecoration(
                              color: UiColors.c1B1B1F,
                              borderRadius: BorderRadius.circular(16)),
                          child: isSecond
                              ? _secondSettingsView()
                              : _firstSettingsView(),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_userCtr.isLogin.value && isSecond)
                    CustomButton(
                      width: double.infinity,
                      height: 46,
                      text: 'logOut'.tr,
                      textColor: UiColors.cDBFFFFFF,
                      bgColors: const [UiColors.c7631EC, UiColors.cA359EF],
                      onTap: () {
                        showLogoutDialog();
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 24.0),
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
          ),
        ),
      ),
    );
  }

  void back() {
    if (isSecond) {
      setState(() {
        isSecond = false;
      });
    } else {
      Get.back();
    }
  }

  Widget _noLoginView() {
    return Container(
      height: 56,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: UiColors.c231831, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'pleaseLogInFirst'.tr,
            style: const TextStyle(
                color: UiColors.cDBFFFFFF,
                fontSize: 14,
                fontWeight: FontWeightExt.semiBold),
          ),
          GestureDetector(
            onTap: () => _userCtr.showLogin(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                  color: UiColors.cBC8EF5,
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                'logIn'.tr,
                style: const TextStyle(
                    color: UiColors.cDBFFFFFF,
                    fontSize: 12,
                    fontWeight: FontWeightExt.semiBold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _userInfoView() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20, top: 24),
          decoration: BoxDecoration(
              color: UiColors.c231831, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 48,
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: (_userCtr.userInfo.value.isVip ?? false)
                        ? Text(
                            'expiresOn'.trArgs([
                              CommonUtil.formatTime(
                                  _userCtr.userInfo.value.expireDate ?? 0)
                            ]),
                            style: const TextStyle(
                                color: UiColors.c99FFFFFF,
                                fontSize: 12,
                                fontWeight: FontWeightExt.semiBold),
                          )
                        : GestureDetector(
                            onTap: () => Get.to(() => const ProPurchasePage()),
                            child: Container(
                                height: 32,
                                decoration: BoxDecoration(
                                    color: UiColors.c99AF6FFF,
                                    borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: Text(
                                  'upgrade'.tr,
                                  style: const TextStyle(
                                      color: UiColors.cDBFFFFFF,
                                      fontSize: 12,
                                      fontWeight: FontWeightExt.semiBold),
                                )),
                          )),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                    color: UiColors.c433258,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16))),
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.dialog(
                            EditNameDialog(onSubmit: (name) {
                              Get.back();
                              _userCtr.userEdit(name);
                            }),
                          );
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 2,
                            ),
                            Obx(() => Text(
                                  maxLines: 1,
                                  _userCtr.userInfo.value.name ?? "",
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      color: UiColors.cDBFFFFFF,
                                      fontWeight: FontWeightExt.semiBold),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Image.asset(
                                'images/icon/ic_edit.png',
                                width: 16,
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/icon/ic_id.png',
                          width: 16,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "${_userCtr.userInfo.value.userId ?? ""}",
                          style: const TextStyle(
                              fontSize: 10,
                              color: UiColors.cBC8EF5,
                              fontWeight: FontWeightExt.semiBold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: "${_userCtr.userInfo.value.userId}"));
                            Fluttertoast.showToast(msg: 'copySucceed'.tr);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Image.asset(
                              'images/icon/ic_copy.png',
                              width: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 36,
                decoration: const BoxDecoration(
                    color: UiColors.c66BE8FF7,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(16))),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      'credits'.tr,
                      style: const TextStyle(
                          color: UiColors.c9771C4,
                          fontSize: 12,
                          fontWeight: FontWeightExt.semiBold),
                    ),
                    const Spacer(),
                    Image.asset(
                      'images/icon/ic_diamonds.png',
                      width: 21,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 8),
                      child: Text(
                        "${_userCtr.userInfo.value.point ?? 0}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeightExt.semiBold),
                      ),
                    ),
                    if (_userCtr.userInfo.value.isVip ?? false)
                      GestureDetector(
                        onTap: () => Get.to(() => const PointPurchasePage()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            'images/icon/ic_add.png',
                            width: 16,
                          ),
                        ),
                      ),
                    const SizedBox(
                      width: 8,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          top: 0,
          child: Image.asset(
            (_userCtr.userInfo.value.isVip ?? false)
                ? 'images/icon/img_settings_top.png'
                : 'images/icon/img_settings_top_disable.png',
            width: 90,
            height: 72,
          ),
        ),
      ],
    );
  }

  Widget _firstSettingsView() {
    return Column(
      children: [
        if (_userCtr.isLogin.value)
          _SettingsItem(
              iconPath: 'images/icon/ic_history.png',
              item: 'creditsUsageHistory'.tr,
              onTap: () {
                Get.to(() => const PointRecordPage());
              }),
        _SettingsItem(
            iconPath: 'images/icon/ic_join.png',
            item: 'joinUs'.tr,
            onTap: () {
              CommonUtil.openUrl(GlobalData.tgUrl);
            }),
        _SettingsItem(
            iconPath: 'images/icon/ic_contact.png',
            item: 'contactUs'.tr,
            onTap: () {
              CommonUtil.sendEmail();
            }),
        _SettingsItem(
            iconPath: 'images/icon/ic_settings.png',
            item: 'settings'.tr,
            onTap: () {
              setState(() {
                isSecond = true;
              });
            }),
      ],
    );
  }

  Widget _secondSettingsView() {
    return Column(
      children: [
        _SettingsItem(
            iconPath: 'images/icon/ic_group.png',
            item: GetPlatform.isAndroid ? 'termsOfUse'.tr : 'eula'.tr,
            onTap: () {
              CommonUtil.openUrl(GetPlatform.isAndroid
                  ? GlobalData.termsOfUseUrl
                  : GlobalData.eulaUrl);
            }),
        _SettingsItem(
            iconPath: 'images/icon/ic_privacy.png',
            item: 'privacyPolicy'.tr,
            onTap: () {
              CommonUtil.openUrl(GlobalData.privacyNoticeUrl);
            }),
        _SettingsItem(
            iconPath: 'images/icon/ic_unsubscribe.png',
            item: 'unsubscribe'.tr,
            onTap: () {
              CommonUtil.openUrl(GetPlatform.isAndroid
                  ? GlobalData.unsubscribeAndroidUrl
                  : GlobalData.unsubscribeIosUrl);
            }),
        if (_userCtr.isLogin.value)
          _SettingsItem(
              iconPath: 'images/icon/ic_delete_account.png',
              item: 'deleteAccount'.tr,
              onTap: () {
                showDeleteAccountDialog();
              })
      ],
    );
  }

  void showLogoutDialog() {
    Get.dialog(
      CustomDialog(
        title: 'logOut'.tr,
        icon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
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
              Fluttertoast.showToast(msg: 'retryDeleteAccountTips'.tr);
              Get.back();
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
    return GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          height: 64,
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
