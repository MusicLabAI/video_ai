import 'package:firebase_analytics/firebase_analytics.dart';

class FireBaseUtil {
  static late FirebaseAnalytics _analytics;

  static late FirebaseAnalyticsObserver observer;

  static void initAnalyticsServices() {
    _analytics = FirebaseAnalytics.instance;
    observer = FirebaseAnalyticsObserver(analytics: _analytics);
  }

  // Firebase Analytics
  static FirebaseAnalytics getFirebaseAnalytics() {
    return _analytics;
  }

  static void logCurrentScreen(String screenName) {
    _analytics.logScreenView(screenName: screenName);
  }

  /// 通用事件记录
  ///
  /// [eventName] 事件名称 [String]类型
  static void logEvent(String eventName, {Map<String, Object>? parameters}) {
    _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  /// 调起支付页面
  static void subscribePageEvent(String fromPage) {
    _analytics.logEvent(
      name: EventName.subscribePage,
      parameters: {'from_event': fromPage},
    );
  }

  /// 调起登录页面
  static void loginPageEvent(String fromPage) {
    _analytics.logEvent(
      name: EventName.loginPage,
      parameters: {'from_event': fromPage},
    );
  }
}

/// 事件名称
class EventName {
  /// 打开登陆页面
  static const String loginPage = 'login_page';

  /// google登陆按钮
  static const String gaLoginBtn = 'ga_login_btn';

  /// google登陆成功
  static const String gaLoginSuccess = 'ga_login_success';

  /// google登陆失败
  static const String gaLoginFailure = 'ga_login_failure';

  /// 邮箱密码登陆按钮
  static const String passwordLoginBtn = 'password_login_btn';

  /// 邮箱密码登陆成功
  static const String passwordLoginSuccess = 'password_login_success';

  /// 邮箱密码登陆失败
  static const String passwordLoginFailure = 'password_login_failure';

  /// 点击Sign up发送邮箱验证
  static const String emailVerification = 'email_verification';

  /// 重发验证邮件
  static const String resendVerification = 'resend_verification';

  /// 重置密码点击‘done’
  static const String resetPassword = 'reset_password';

  /// apple登陆按钮
  static const String apLoginBtn = 'ap_login_btn';

  /// apple登陆成功
  static const String apLoginSuccess = 'ap_login_success';

  /// apple登陆失败
  static const String apLoginFailure = 'ap_login_failure';

  /// 首页点击个人中心
  static const String homeSettingBtn = 'home_setting_btn';

  /// 首页点击‘Identify’
  static const String homeIdentify = 'home_identify';

  /// 首页点击‘Dianose’
  static const String homeDianose = 'home_dianose';

  /// 首页点击底部拍照icon
  static const String homeShootBttom = 'home_shoot_buttom';

  /// 调起支付页面
  static const String subscribePage = 'subscribe_page';

  /// 用户发起会员订阅
  static const String memberPurchaseSelect = 'member_purchase_select';

  /// 会员付款成功
  static const String memberPurchaseSuccess = 'member_purchase_success';

  /// 会员订阅界面‘restore’
  static const String subscribeRestore = 'subscribe_restore';

  /// 拍照界面点击拍照提示icon
  static const String shootHelp = 'shoot_help';

  /// 点击相册选图icon
  static const String shootAlbum = 'shoot_album';

  /// 拍照界面点击‘Dianose’
  static const String shootDianose = 'shoot_dianose';

  /// 拍照界面点击‘Identify’
  static const String shootIdentify = 'shoot_identify';

  /// 详情页点击‘save’按钮
  static const String infoSave = 'info_save';

  /// 详情页点击‘share’icon
  static const String infoShare = 'info_share';

  /// 详情页点击‘拍照’icon
  static const String infoShoot = 'info_shoot';

  /// 诊断详情页点击‘plant info’
  static const String dianoseInfoPlantinfo = 'dianose_info_plantinfo';

  /// 诊断详情页点击‘Retake’
  static const String dianoseInfoRetake = 'dianose_info_retake';

  /// 列表页点击rename
  static const String listRename = 'list_rename';

  /// 列表页点击remove
  static const String listRemove = 'list_remove';

  /// 用户remove弹窗二次确认删除
  static const String listRemoveAgree = 'list_remove_agree';

  /// 设置界面分享app
  static const String settingShareApp = 'setting_share_app';
}
