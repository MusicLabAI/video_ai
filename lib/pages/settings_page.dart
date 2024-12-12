import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/request.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/point_record_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';
import 'package:video_ai/pages/mine_page.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/dialogs.dart';
import 'package:video_ai/widgets/loading_widget.dart';

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
    FireBaseUtil.logEventPageView(PageName.settingsPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/ic_back.png'),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: UiColors.c1B1B1F,
                            borderRadius: BorderRadius.circular(16)),
                        child: _secondSettingsView(),
                      ),
                    ],
                  ),
                )),
                const SizedBox(
                  height: 20,
                ),
                if (_userCtr.isLogin.value)
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
    );
  }

  Widget _secondSettingsView() {
    return Column(
      children: [
        SettingsItem(
            iconPath: 'assets/images/ic_group.png',
            item: GetPlatform.isAndroid ? 'termsOfUse'.tr : 'eula'.tr,
            onTap: () {
              CommonUtil.openUrl(GetPlatform.isAndroid
                  ? GlobalData.termsOfUseUrl
                  : GlobalData.eulaUrl);
            }),
        SettingsItem(
            iconPath: 'assets/images/ic_privacy.png',
            item: 'privacyPolicy'.tr,
            onTap: () {
              CommonUtil.openUrl(GlobalData.privacyNoticeUrl);
            }),
        SettingsItem(
            iconPath: 'assets/images/ic_unsubscribe.png',
            item: 'unsubscribe'.tr,
            onTap: () {
              CommonUtil.openUrl(GetPlatform.isAndroid
                  ? GlobalData.unsubscribeAndroidUrl
                  : GlobalData.unsubscribeIosUrl);
              FireBaseUtil.logEventButtonClick(
                  PageName.settingsPage, 'unsubscribe_entry');
            }),
        if (_userCtr.isLogin.value)
          SettingsItem(
              iconPath: 'assets/images/ic_delete_account.png',
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
            'assets/images/img_log_out.png',
            width: 70,
          ),
        ),
        confirmText: 'logOut'.tr,
        cancelText: 'cancel'.tr,
        subText: 'logOutTips'.tr,
        onConfirm: () async {
          await _userCtr.logout();
          Get.back();
          FireBaseUtil.logEvent(EventName.logoutSuccessful);
        },
      ),
    );
  }

  void showDeleteAccountDialog() {
    Get.dialog(CustomDialog(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Image.asset(
          'assets/images/ic_warn.png',
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
        Get.dialog(const LoadingWidget(), barrierDismissible: false);
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
        FireBaseUtil.logEvent(EventName.deleteAccount);
      },
    ));
  }
}
