import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/pages/reset_pwd_page.dart';
import 'package:video_ai/pages/sign_up_page.dart';

import '../common/global_data.dart';
import '../common/ui_colors.dart';
import '../controllers/user_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textformfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  bool _isButtonEnabled = false;
  final _formKey = GlobalKey<FormState>();
  final _userCtr = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    FireBaseUtil.logEventPageView('email_login_page');
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
      _isButtonEnabled = email.isNotEmpty && pwd.isNotEmpty;
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
                onTap: () {
                  Get.back();
                } ,
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
                            'logIn'.tr,
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
                            text: 'logIn'.tr,
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
                                _userCtr.emailLogIn(
                                    _emailController.text, _pwdController.text);
                                Get.until((route) => Get.currentRoute == '/');
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Get.to(() => const ResetPwdPage()),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                                  child: Text(
                                    'forgotPassword'.tr,
                                    style: const TextStyle(
                                        color: UiColors.cBC8EF5, fontSize: 12),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.off(() => const SignUpPage());
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                                  child: Text(
                                    'signUp'.tr,
                                    style: const TextStyle(
                                        color: UiColors.cBC8EF5, fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]),
                  )),
            ]),
          )),
    );
  }
}
