import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_ai/widgets/login.dart';

import '../api/dio.dart';
import '../api/request.dart';
import '../common/rsa.dart';
import '../models/user_model.dart';
import '../widgets/loading_dialog.dart';
import 'mine_controller.dart';

class UserController extends GetxController {
  var isLogin = false.obs;
  var userInfo = UserInfoModel().obs;

  static const int loginGoogle = 2;
  static const int loginApple = 5;

  void showLogin() {
    Get.bottomSheet(LoginWidget());
  }

  /// loginType 5 apple  2 google
  Future<void> login(String uid, String? email, int loginType) async {
    print('uid: $uid --> email: $email');
    try {
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
      Get.find<MineController>().onRefresh();
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
}