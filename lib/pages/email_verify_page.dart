import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/firebase_util.dart';

import '../common/ui_colors.dart';
import '../controllers/user_controller.dart';
import '../widgets/custom_button.dart';

class EmailVerifyPage extends StatefulWidget {
  final String email;
  final bool isSignUp;

  const EmailVerifyPage(
      {super.key, required this.email, required this.isSignUp});

  @override
  State<EmailVerifyPage> createState() {
    return _EmailVerifyPageState();
  }
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  final _userCtr = Get.find<UserController>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    FireBaseUtil.logEventPageView(PageName.forgetPasswordVerifyEmailPage);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!widget.isSignUp) {
      return;
    }
    const period = Duration(seconds: 10);
    _timer = Timer.periodic(period, (timer) {
      _userCtr.emailVerifiedReload(isSignUp: widget.isSignUp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0, top: 16),
                child: Image.asset(
                  'images/icon/ic_close.png',
                  width: 24,
                ),
              ),
              onTap: () => Get.back(),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 24.0, right: 24.0, top: 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isSignUp
                        ? 'emailVerification'.tr
                        : 'resetPassword'.tr,
                    style: const TextStyle(
                        color: UiColors.cDBFFFFFF,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32,),
                  Text(
                    widget.isSignUp
                        ? 'emailSentTip'.tr
                        : 'resetPasswordTip'.tr,
                    style: const TextStyle(
                      color: UiColors.cDBFFFFFF,
                      fontSize: 14,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      widget.email,
                      style: const TextStyle(
                          color: UiColors.cBC8EF5,
                          fontSize: 18,
                          fontWeight: FontWeightExt.bold),
                    ),
                  ),
                  Text(
                    'resendEmailTip'.tr,
                    style: const TextStyle(
                      color: UiColors.c99FFFFFF,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => widget.isSignUp ? _userCtr.emailSend() : _userCtr.sendPasswordResetEmail(widget.email),
                        child: Text(
                          'clickHere'.tr,
                          style: const TextStyle(
                            color: UiColors.cBC8EF5,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6,),
                      Text(
                        'toResendEmail'.tr,
                        style: const TextStyle(
                          color: UiColors.c99FFFFFF,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomButton(
                    width: double.infinity,
                    height: 46,
                    text: widget.isSignUp
                        ? 'refreshVerificationStatus'.tr
                        : 'returnToLogin'.tr,
                    textColor: UiColors.cDBFFFFFF,
                    bgColors: const [UiColors.c7631EC, UiColors.cBC8EF5],
                    onTap: () {
                      if (widget.isSignUp) {
                        _userCtr.emailVerifiedReload();
                      } else {
                        Get.back();
                        Get.back();
                      }
                    },
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}
