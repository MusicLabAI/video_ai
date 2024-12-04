
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:video_ai/models/shop_model.dart';

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
  
  /// 页面浏览
  static void logEventPageView(String pageName) {
    _analytics.logEvent(
      name: EventName.pageView,
      parameters: {'pageName': pageName},
    );
  }

  /// 按钮点击
  static void logEventButtonClick(String pageName, String buttonName, {String popupName = ''}) {
    _analytics.logEvent(
      name: EventName.buttonClick,
      parameters: {'pageName': pageName, 'buttonName': buttonName, 'popupName': popupName},
    );
  }

  /// 弹窗展示
  static void logEventPopupView(String popupName) {
    _analytics.logEvent(
      name: EventName.popupView,
      parameters: {'popupName': popupName},
    );
  }

  /// 创建订单
  static void logEventCreateOrder(ShopModel currentItem, String pageName) {
    String? productId = currentItem.shopId;
    int? productType = currentItem.shopType;
    if (productId != null && productType != null) {
      _analytics.logEvent(
        name: EventName.createOrder,
        parameters: {'productId': productId, 'productType': productType, 'pageName': pageName},
      );
    }
  }

  /// 支付订单
  static void logEventPayOrder(ShopModel currentItem, bool result, String pageName) {
    String? productId = currentItem.shopId;
    int? productType = currentItem.shopType;
    if (productId != null && productType != null) {
      _analytics.logEvent(
        name: EventName.payOrder,
        parameters: {'productId': productId, 'result': '$result', 'productType': productType, 'pageName': pageName},
      );
    }
  }

  /// 消耗订单
  static void logEventConsumptionOrder(ShopModel currentItem, bool result, String pageName) {
    String? productId = currentItem.shopId;
    int? productType = currentItem.shopType;
    if (productId != null && productType != null) {
      _analytics.logEvent(
        name: EventName.consumptionOrder,
        parameters: {'productId': productId, 'result': '$result', 'productType': productType, 'pageName': pageName},
      );
    }
  }
  
}

/// 事件名称
class EventName {
  
  /// 页面浏览
  static const String pageView = 'page_view';
 
  /// 按钮点击
  static const String buttonClick = 'button_click';

  /// 弹窗展示
  static const String popupView = 'popup_view';

  /// 请求创作内容
  static const String requestCreation = 'request_creation';
  
  /// 保存创作结果
  static const String saveCreation = 'save_creation';
  
  /// 删除创作结果
  static const String deleteCreation = 'delete_creation';

  /// 拉起分享
  static const String shareRequest = 'share_request';

  /// 创建订单
  static const String createOrder = 'create_order';
  
  /// 支付订单
  static const String payOrder = 'pay_order';

  /// 消耗订单
  static const String consumptionOrder = 'consumption_order';

  /// 注册成功
  static const String registrationSuccessful = 'registration_successful';

  /// 登陆成功
  static const String loginSuccessful = 'login_successful';

  /// 用户名修改成功
  static const String usernameEditSuccessful = 'username_edit_successful';

  /// 用户名修改失败
  static const String usernameEditFailed = 'username_edit_failed';

  /// 删除账户
  static const String deleteAccount = 'delete_account';

  /// 退出登录
  static const String logoutSuccessful = 'logout_successful';
}

class PageName  {
  /// 创作页
  static const String createPage = 'create_page';

  /// 个人页
  static const String minePage = 'mine_page';

  /// 忘记密码 
  static const String forgetPasswordVerifyEmailPage = 'forget_password_verify_email_page';

  /// 邮箱登录页
  static const String emailLoginPage = 'email_login_page';

  /// 特效首页
  static const String specialEffectsPage = 'special_effects_page';

  /// 历史页面
  static const String historyPage = 'history_page';

  /// 点数购买页面
  static const String creditsPurchasePage = 'credits_purchase_page';

  /// 积分历史页面
  static const String creditsPage = 'credits_page';

  /// 会员购买页面
  static const String proPurchasePage = 'pro_purchase_page';

  /// 忘记密码页面
  static const String forgetPasswordPage = 'forget_password_page';

  /// 设置页面
  static const String settingsPage = 'settings_page';

  /// 邮箱注册页面
  static const String emailSignupPage = 'email_signup_page';

  /// 视频详情页面
  static const String videoPlayPage = 'video_play_page';

  /// AiStudio页面
  static const String aiStudioPage = 'aiStudio_page';

  /// 特效详情页
  static const String effectDetailsPage = 'effect_details_page';

  /// 文生视频案例详情页
  static const String exampleDetailsPage = 'example_details_page';

  /// 弹窗会员详情页
  static const String proPopupPage = 'pro_popup_page';

  /// 弹窗点数详情页
  static const String creditsPopupPage = 'credits_popup_page';
}