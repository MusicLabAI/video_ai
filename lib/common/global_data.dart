class GlobalData {

  static const String debugBaseUrl = 'http://192.168.0.128:18100';

  static const String releaseBaseUrl = 'https://api.sunomusic.ai';

  /// 用户协议
  static String termsOfUseUrl = 'https://superinteractica.ai/VideoAIterms_of_use.html';

  /// 用户协议
  static String eulaUrl = 'https://superinteractica.ai/VideoAIEULA.html';

  /// 隐私协议
  static String privacyNoticeUrl = 'https://superinteractica.ai/VideoAIprivacy_policy.html';

  static String versionName = '';
  static String packageName = '';

  static String emailReg = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static String passwordReg = r'^.{6,}$';
}
