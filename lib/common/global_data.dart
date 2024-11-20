import 'buy_shop.dart';

class GlobalData {

  static const String debugBaseUrl = 'http://192.168.0.128:18100';

  static const String releaseBaseUrl = 'https://api.superinteractica.ai';

  /// 用户协议
  static String termsOfUseUrl = 'https://superinteractica.ai/VideoAIterms_of_use.html';

  /// 用户协议
  static String eulaUrl = 'https://superinteractica.ai/VideoAIEULA.html';

  /// 隐私协议
  static String privacyNoticeUrl = 'https://superinteractica.ai/VideoAIprivacy_policy.html';

  /// android去掉订阅
  static String unsubscribeAndroidUrl = 'https://support.google.com/googleplay/answer/7018481';

  /// ios去掉订阅
  static String unsubscribeIosUrl = 'https://support.apple.com/en-us/118428';

  /// tg
  static String tgUrl = 'https://t.me/+30nOnsRynCAyYjNl';

  static String versionName = '';
  static String packageName = '';

  static String emailReg = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static String passwordReg = r'^.{6,}$';

  static BuyShop buyShop = BuyShop();

  static String KEY_CREATION_LAYOUT_SWITCH = "key_creation_layout_switch";
  static bool isCreationLayoutSwitch = false;
}
