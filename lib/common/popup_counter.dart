import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PopupCounter {
  static const String _popupCountKey = 'popup_count';
  static const String _lastPopupDateKey = 'last_popup_date';

  // 获取弹框次数
  static Future<int> getPopupCount() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPopupDate = prefs.getString(_lastPopupDateKey);
    final currentDate = _getCurrentDateString();

    // 如果不是同一天，重置计数
    if (lastPopupDate != currentDate) {
      await _resetPopupCount(prefs);
      return 0;
    }

    return prefs.getInt(_popupCountKey) ?? 0;
  }

  // 增加弹框次数
  static Future<void> incrementPopupCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getPopupCount();

    // 更新弹框次数
    await prefs.setInt(_popupCountKey, currentCount + 1);

    // 记录当前日期
    await prefs.setString(_lastPopupDateKey, _getCurrentDateString());
  }

  // 重置弹框次数
  static Future<void> _resetPopupCount(SharedPreferences prefs) async {
    await prefs.setInt(_popupCountKey, 0);
    await prefs.setString(_lastPopupDateKey, _getCurrentDateString());
  }

  // 获取当前日期字符串 (只取到天)
  static String _getCurrentDateString() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
