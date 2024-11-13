import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/pages/email_verify_page.dart';
import 'package:video_ai/pages/login_page.dart';
import 'package:video_ai/widgets/custom_button.dart';

import '../common/ui_colors.dart';
import '../widgets/custom_textformfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final _userCtr = Get.find<UserController>();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  bool _isButtonEnabled = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _pwdController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _pwdController.removeListener(_updateButtonState);
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    // Check if the input is valid and update the button state
    final email = _emailController.text;
    final pwd = _pwdController.text;
    // 定义邮箱和密码的正则表达式
    final emailRegExp = RegExp(GlobalData.emailReg);
    final pwdRegExp = RegExp(GlobalData.passwordReg);

    // 使用正则表达式验证
    setState(() {
      _isButtonEnabled = email.length >= 3 && pwd.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.hideKeyboard(context),
      child: Scaffold(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'signUp'.tr,
                            style: const TextStyle(
                                color: UiColors.cDBFFFFFF,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16, bottom: 8.0),
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
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16, bottom: 8.0),
                            child: Text(
                              'password'.tr,
                              style: const TextStyle(
                                  color: UiColors.cDBFFFFFF, fontSize: 14),
                            ),
                          ),
                          CustomTextFormField(
                            controller: _pwdController,
                            errorText: 'passwordHintText'.tr,
                            hintText: 'passwordHintText'.tr,
                            isPwd: true,
                            reg: GlobalData.passwordReg,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomButton(
                            width: double.infinity,
                            height: 46,
                            text: 'signUp'.tr,
                            textColor: UiColors.cDBFFFFFF,
                            bgColors: _isButtonEnabled
                                ? const [UiColors.c7631EC, UiColors.cBC8EF5]
                                : const [UiColors.c30333F, UiColors.c30333F],
                            borderRadius: 12,
                            onTap: () {
                              if (!_isButtonEnabled) {
                                return;
                              }
                              if (_formKey.currentState?.validate() ?? false) {
                                _submit();
                              }
                            },
                          ),
                          GestureDetector(
                            onTap: () => Get.off(() => const LoginPage()),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                              child: Text(
                                'logIn'.tr,
                                style: const TextStyle(
                                    color: UiColors.cBC8EF5, fontSize: 12),
                              ),
                            ),
                          ),
                        ]),
                  )),
            ]),
          )),
    );
  }

  Future<void> _submit() async {
    CommonUtil.hideKeyboard(context);
    await _userCtr.emailCreateUser(_emailController.text, _pwdController.text);
    Get.to(() => EmailVerifyPage(email: _emailController.text, isSignUp: true));
  }
}
