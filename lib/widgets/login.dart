import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/ui_colors.dart';

import '../common/global_data.dart';
import '../controllers/user_controller.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});

  final bool isAndroid = GetPlatform.isAndroid;

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
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 290,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        decoration: const BoxDecoration(
            color: UiColors.c262434,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'signIn'.tr,
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
            GestureDetector(
              onTap: () async {
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
                if (isAndroid) {
                  UserCredential userCredential = await signInWithGoogle();
                  final uid = userCredential.user?.uid;
                  if (uid?.isNotEmpty == true) {
                    await userController.login(uid!, userCredential.user?.email, UserController.loginGoogle);
                  }
                } else {
                  var credentialAppleID = await signInWithApple();
                  if (credentialAppleID.userIdentifier?.isNotEmpty == true) {
                    await userController.login(credentialAppleID.userIdentifier!, credentialAppleID.email, UserController.loginApple);
                  }
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isAndroid ? UiColors.cBC8EF5 : UiColors.cA754FC,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    CommonUtil.startUrl(GlobalData.termsOfUseUrl);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'termsOfUse'.tr,
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
                    CommonUtil.startUrl(GlobalData.privacyNoticeUrl);
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
      ),
    );
  }
}
