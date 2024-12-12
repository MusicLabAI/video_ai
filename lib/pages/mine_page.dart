import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/point_record_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';
import 'package:video_ai/pages/settings_page.dart';
import 'package:video_ai/widgets/dialogs.dart';

import '../common/common_util.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final _userCtr = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    FireBaseUtil.logEventPageView(PageName.minePage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userCtr.getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'mine'.tr,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeightExt.semiBold),
              ),
            ),
            if (!_userCtr.isLogin.value)
              Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: _noLoginView()),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_userCtr.isLogin.value) _userInfoView(),
                        Container(
                          decoration: BoxDecoration(
                              color: UiColors.c1B1B1F,
                              borderRadius: BorderRadius.circular(16)),
                          child: _firstSettingsView(),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
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
                            onTap: () {
                              Get.to(() => const ProPurchasePage());
                              FireBaseUtil.logEventButtonClick(
                                  PageName.minePage, 'mine_pro_button');
                            },
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
                          FireBaseUtil.logEventPopupView(
                              'change_username_popup');
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
                                'assets/images/ic_edit.png',
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
                          'assets/images/ic_id.png',
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
                            FireBaseUtil.logEventButtonClick(
                                PageName.minePage, 'copy_id_button');
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Image.asset(
                              'assets/images/ic_copy.png',
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
                      'assets/images/ic_diamonds.png',
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
                        onTap: () {
                          Get.to(() => const PointPurchasePage());
                          FireBaseUtil.logEventButtonClick(
                              PageName.minePage, 'mine_credits_button');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            'assets/images/ic_add.png',
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
                ? 'assets/images/img_settings_top.png'
                : 'assets/images/img_settings_top_disable.png',
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
          SettingsItem(
              iconPath: 'assets/images/ic_history.png',
              item: 'creditsUsageHistory'.tr,
              onTap: () {
                Get.to(() => const PointRecordPage());
              }),
        SettingsItem(
            iconPath: 'assets/images/ic_join.png',
            item: 'joinUs'.tr,
            onTap: () {
              CommonUtil.openUrl(GlobalData.tgUrl);
              FireBaseUtil.logEventButtonClick(
                  PageName.minePage, 'telegram_entry');
            }),
        SettingsItem(
            iconPath: 'assets/images/ic_contact.png',
            item: 'contactUs'.tr,
            onTap: () {
              CommonUtil.sendEmail();
              FireBaseUtil.logEventButtonClick(
                  PageName.minePage, 'email_entry');
            }),
        SettingsItem(
            iconPath: 'assets/images/ic_settings.png',
            item: 'settings'.tr,
            onTap: () {
              FireBaseUtil.logEventPageView(PageName.minePage);
              Get.to(() => const SettingsPage());
            }),
      ],
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem(
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
                'assets/images/ic_right.png',
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
