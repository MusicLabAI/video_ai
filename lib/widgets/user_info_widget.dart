import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';

import '../controllers/user_controller.dart';

class UserInfoWidget extends StatelessWidget {
  UserInfoWidget({super.key});

  final UserController _userCtr = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return (_userCtr.isLogin.value && _userCtr.userInfo.value.isVip == true)
        ? GestureDetector(
            onTap: () => Get.to(() => const PointPurchasePage()),
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: UiColors.c30333F)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/icon/ic_diamonds.png'),
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
              if (!_userCtr.isLogin.value) {
                _userCtr.showLogin();
                return;
              }
              Get.to(() => const ProPurchasePage());
            },
            child: Image.asset(
              'images/icon/img_pro.png',
              width: 76,
              height: 32,
            ));
  }
}
