import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/widgets/login_widget.dart';

import '../api/dio.dart';
import '../api/request.dart';
import '../common/rsa.dart';
import '../models/user_model.dart';
import '../widgets/loading_dialog.dart';
import 'mine_controller.dart';

class UserController extends GetxController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var isLogin = false.obs;
  var userInfo = UserInfoModel().obs;

  static const int loginGoogle = 2;
  static const int loginApple = 5;

  void showLogin() {
    Get.bottomSheet(LoginWidget());
    FireBaseUtil.logEventPopupView('login_popup');
  }

  @override
  onInit() {
    super.onInit();
    firebaseAuth.setLanguageCode(Get.deviceLocale?.languageCode);
  }

  @override
  onClose() {
    if (firebaseAuth.currentUser != null) {
      final isVerified = firebaseAuth.currentUser?.emailVerified ?? false;
      if (!isVerified) {
        try {
          firebaseAuth.currentUser?.delete();
        } catch (e) {
          Get.log(e.toString(), isError: true);
        }
      }
    }
    super.onClose();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'passwordWeak'.tr);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'accountExists'.tr);
      } else {
        Fluttertoast.showToast(msg: e.message ?? 'error');
      }
      Get.log(e.toString(), isError: true);
      rethrow;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  /// 刷新用户验证信息
  Future<bool> emailVerifiedReload({bool isSignUp = false}) async {
    bool isVerified = firebaseAuth.currentUser?.emailVerified ?? false;
    if (isVerified) {
      return true;
    }
    try {
      await firebaseAuth.currentUser?.reload();
      isVerified = firebaseAuth.currentUser?.emailVerified ?? false;
      if (isVerified) {
        if (isSignUp) {
          FireBaseUtil.logEvent(EventName.registrationSuccessful);
        }
        final uid = firebaseAuth.currentUser?.uid;
        if (uid != null) {
          Get.dialog(const LoadingDialog(), barrierDismissible: false);
          await login(uid, firebaseAuth.currentUser?.email, loginGoogle);
          Get.until((route) => Get.currentRoute == '/');
        }
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
    return isVerified;
  }

  Future<void> emailSend() async {
    final isVerified = firebaseAuth.currentUser?.emailVerified ?? false;
    if (isVerified) {
      return;
    }
    await firebaseAuth.currentUser?.sendEmailVerification();
  }

  Future<void> emailCreateUser(String email, String password) async {
    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emailSend();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'passwordWeak'.tr);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'accountExists'.tr);
      } else {
        Fluttertoast.showToast(msg: e.message ?? 'create error');
      }
      Get.log(e.toString(), isError: true);
      rethrow;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  Future<void> emailLogIn(String email, String password) async {
    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      final currentCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = currentCredential.user?.uid;
      if (uid != null) {
        await login(uid, currentCredential.user?.email, loginGoogle);
        Get.back(closeOverlays: true);
        Get.back();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'emailNoFound'.tr);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'passwordWrong'.tr);
      } else {
        Fluttertoast.showToast(msg: e.message ?? 'loginError'.tr);
      }
      Get.log(e.toString(), isError: true);
      FireBaseUtil.logEvent(EventName.loginSuccessful);
    } catch (e) {
      Get.log(e.toString(), isError: true);
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  /// loginType 5 apple  2 google
  Future<void> login(String uid, String? email, int loginType) async {
    print('uid: $uid --> email: $email');
    try {
      final uidEncode = await Rsa.encodeString(uid);
      final emailEncode = await Rsa.encodeString(email);
      final res =
          await Request.oneClickLogin(uidEncode, emailEncode, loginType);
      final token = res['token'];
      if (token == null || token.isEmpty) {
        throw 'token 为空';
      }

      DioUtil.token = token;
      DioUtil.resetDio();
      isLogin.value = true;
      userInfo.value = UserInfoModel.fromJson(res);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('token', token);
      });
      Fluttertoast.showToast(msg: 'loginSucceed'.tr);
      Get.find<MineController>().onRefresh();
      FireBaseUtil.logEvent(EventName.loginSuccessful);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> getUserInfo() async {
    if (DioUtil.token.isBlank ?? true) {
      isLogin.value = false;
      return;
    } else {
      isLogin.value = true;
    }
    final res = await Request.userinfo();
    userInfo.value = UserInfoModel.fromJson(res);
    if (userInfo.value.token?.isNotEmpty ?? false) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('token', userInfo.value.token!);
      });
    }
  }

  Future<void> logout() async {
    isLogin.value = false;
    userInfo.value = UserInfoModel();
    DioUtil.token = '';
    DioUtil.resetDio();
    SharedPreferences.getInstance().then((value) async {
      value.remove('token');
    });
    Get.find<MineController>().onRefresh();
  }

  Future<void> userEdit(String nickname) async {
    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      await Request.userEdit(nickname);
      final u = userInfo.value.toMap();
      u['name'] = nickname;
      userInfo.value = UserInfoModel.fromJson(u);
      FireBaseUtil.logEvent(EventName.usernameEditSuccessful);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      FireBaseUtil.logEvent(EventName.usernameEditFailed);
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }
}
