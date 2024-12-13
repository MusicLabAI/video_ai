import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';

import '../common/common_util.dart';
import '../controllers/user_controller.dart';

class UserInfoWidget extends StatelessWidget {
  UserInfoWidget({super.key});

  final UserController _userCtr = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
        () => (_userCtr.isLogin.value && _userCtr.userInfo.value.isVip == true)
            ? GestureDetector(
                onTap: () {
                  CommonUtil.hideKeyboard(context);
                  Get.to(() => const PointPurchasePage());
                  FireBaseUtil.logEventButtonClick(PageName.createPage, 'global_credits_button');
                },
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: UiColors.c99000000,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: UiColors.c33FFFFFF)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/ic_diamonds.png'),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${_userCtr.userInfo.value.point ?? '0'}",
                        style: TextStyle(
                            color: UiColors.c99FFFFFF,
                            fontSize: 14,
                            fontWeight: FontWeightExt.medium),
                      ),
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  CommonUtil.hideKeyboard(context);
                  Get.to(() => const ProPurchasePage());
                  FireBaseUtil.logEventButtonClick(PageName.createPage, 'global_pro_button');
                },
                child: Image.asset(
                  'assets/images/img_pro.png',
                  width: 76,
                  height: 32,
                )));
  }
}
