import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/pages/login_page.dart';
import 'package:video_ai/pages/sign_up_page.dart';
import 'package:video_ai/widgets/loading_dialog.dart';

import '../common/global_data.dart';
import '../controllers/user_controller.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final bool isAndroid = GetPlatform.isAndroid;

  bool isSignUp = false;

  Future<AuthorizationCredentialAppleID> signInWithApple() async {
    try {
      return await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ]);
    } on SignInWithAppleAuthorizationException catch (e) {
      Get.log(e.toString(), isError: true);
      Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.CENTER);
      rethrow;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      var googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      var account = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await account?.authentication;
      if (googleAuth == null) {
        throw 'googleAuth is null';
      }
      var credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (e) {
      Get.log(e.toString(), isError: true);
      Fluttertoast.showToast(
          msg: e.message ?? 'login error', gravity: ToastGravity.CENTER);
      rethrow;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    return Container(
      height: 305,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: const BoxDecoration(
          color: UiColors.c262434,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    isSignUp ? 'signUp'.tr : 'logIn'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const ImageIcon(
                      AssetImage('images/icon/ic_close.png'),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              try {
                Get.dialog(const LoadingDialog());
                if (isAndroid) {
                  UserCredential userCredential = await signInWithGoogle();
                  final uid = userCredential.user?.uid;
                  if (uid?.isNotEmpty == true) {
                    await userController.login(
                        uid!,
                        userCredential.user?.email,
                        UserController.loginGoogle);
                  }
                } else {
                  var credentialAppleID = await signInWithApple();
                  if (credentialAppleID.userIdentifier?.isNotEmpty == true) {
                    await userController.login(
                        credentialAppleID.userIdentifier!,
                        credentialAppleID.email,
                        UserController.loginApple);
                  }
                }
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
                Get.back();
              } catch (e) {
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
              }
            },
            child: Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: UiColors.cA754FC,
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                        isAndroid
                            ? 'images/icon/ic_google.png'
                            : 'images/icon/ic_apple.png',
                        width: 18),
                    const SizedBox(width: 8),
                    Text(
                        isAndroid
                            ? 'continueWithGoogle'.tr
                            : 'continueWithApple'.tr,
                        style: const TextStyle(
                            color: UiColors.cDBFFFFFF,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          if (isAndroid) ...[
            GestureDetector(
              onTap: () {
                if (isSignUp) {
                  Get.to(() =>  const SignUpPage(), preventDuplicates: false);
                } else {
                  Get.to(() =>  const LoginPage(), preventDuplicates: false);
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: UiColors.cBC8EF5,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('images/icon/ic_email.png', width: 18),
                      const SizedBox(width: 8),
                      Text(
                          isSignUp
                              ? 'signUpWithEmail'.tr
                              : 'logInWithEmail'.tr,
                          style: const TextStyle(
                              color: UiColors.cDBFFFFFF,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSignUp = !isSignUp;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isSignUp ? 'haveAccount'.tr : 'noAccount'.tr,
                      style: const TextStyle(
                          color: UiColors.c848484, fontSize: 12),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      isSignUp ? 'logIn'.tr : 'signUp'.tr,
                      style: const TextStyle(
                          color: UiColors.cA754FC, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  CommonUtil.openUrl(isAndroid ? GlobalData.termsOfUseUrl : GlobalData.eulaUrl);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    isAndroid ? 'termsOfUse'.tr : 'eula'.tr,
                    style: TextStyle(
                      color: UiColors.c848484,
                      fontSize: 12,
                      fontWeight: FontWeightExt.medium,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '|',
                  style: TextStyle(
                    color: UiColors.c848484,
                    fontSize: 12,
                    fontWeight: FontWeightExt.medium,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  CommonUtil.openUrl(GlobalData.privacyNoticeUrl);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'privacyPolicy'.tr,
                    style: TextStyle(
                      color: UiColors.c848484,
                      fontSize: 12,
                      fontWeight: FontWeightExt.medium,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
