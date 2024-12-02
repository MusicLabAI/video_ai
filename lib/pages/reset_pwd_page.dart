import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/pages/email_verify_page.dart';

import '../common/common_util.dart';
import '../common/global_data.dart';
import '../common/ui_colors.dart';
import '../controllers/user_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textformfield.dart';

class ResetPwdPage extends StatefulWidget {
  const ResetPwdPage({super.key});

  @override
  State<ResetPwdPage> createState() {
    return _ResetPwdPageState();
  }
}

class _ResetPwdPageState extends State<ResetPwdPage> {
  final _emailController = TextEditingController();
  var _isButtonEnabled = false;
  final _formKey = GlobalKey<FormState>();
  final _userCtr = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    FireBaseUtil.logEventPageView(PageName.forgetPasswordPage);
    _emailController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _emailController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    // Check if the input is valid and update the button state
    final email = _emailController.text;
    setState(() {
      _isButtonEnabled = email.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.hideKeyboard(context),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, top: 16),
                  child: Image.asset('assets/images/ic_close.png', width: 24,),
                ),
                onTap: () => Get.back(),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 24.0, right: 24.0, top: 48.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'resetPassword'.tr,
                            style: const TextStyle(
                                color: UiColors.cDBFFFFFF,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8.0),
                            child: Text(
                              'email'.tr,
                              style: const TextStyle(
                                  color: UiColors.cDBFFFFFF, fontSize: 14),
                            ),
                          ),
                          CustomTextFormField(
                            controller: _emailController,
                            errorText: 'emailErrorText'.tr,
                            hintText: 'emailHintText'.tr,
                            reg: GlobalData.emailReg,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomButton(
                            width: double.infinity,
                            height: 46,
                            text: 'resetPassword'.tr,
                            textColor: UiColors.cDBFFFFFF,
                            bgColors: _isButtonEnabled
                                ? const [UiColors.c7631EC, UiColors.cBC8EF5]
                                : const [UiColors.c30333F, UiColors.c30333F],
                            onTap: () {
                              if (!_isButtonEnabled) {
                                return;
                              }
                              if (_formKey.currentState?.validate() ?? false) {
                                CommonUtil.hideKeyboard(context);
                                _userCtr.sendPasswordResetEmail(_emailController.text);
                                Get.to(() => EmailVerifyPage(email: _emailController.text, isSignUp: false));
                              }
                            },
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'returnToLogin'.tr,
                                style: const TextStyle(
                                    fontSize: 12, color: UiColors.cBC8EF5),
                              ),
                            ),
                          )
                        ]),
                  )),
            ]),
          )),
    );
  }
}
