import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:video_ai/widgets/login.dart';

import '../api/dio.dart';
import '../api/request.dart';
import '../common/rsa.dart';
import '../models/user_model.dart';
import '../widgets/loading_dialog.dart';

class UserController extends GetxController {
  var isLogin = false.obs;
  var userInfo = UserInfoModel().obs;

  static const int loginGoogle = 2;
  static const int loginApple = 5;

  void showLogin() {
    Get.dialog(LoginWidget());
  }

  /// loginType 5 apple  2 google
  Future<void> login(String uid, String? email, int loginType) async {
    print('uid: $uid --> email: $email');
    try {
      Get.dialog(const LoadingDialog());
      final uidEncode = await Rsa.encodeString(uid);
      final emailEncode = await Rsa.encodeString(email);
      final res = await Request.oneClickLogin(uidEncode, emailEncode, loginType);
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
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
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
}