class GlobalData {

  static const String debugBaseUrl = 'http://192.168.0.128:18100';

  static const String releaseBaseUrl = 'https://api.sunomusic.ai';

  /// 用户协议
  static String termsOfUseUrl = 'https://www.sunomusic.ai/VideoLabterms_of_use.html';

  /// 隐私协议
  static String privacyNoticeUrl = 'https://www.sunomusic.ai/VideoLabprivacy_policy.html';

  static String versionName = '';
  static String packageName = '';

  static String emailReg = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static String passwordReg = r'^.{6,}$';
}