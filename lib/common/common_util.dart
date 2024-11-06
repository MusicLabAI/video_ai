import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonUtil {
  static Function() debounce(Function fn, [int t = 500]) {
    Timer? debounce;
    return () {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      } else {
        fn();
      }
      debounce = Timer(Duration(milliseconds: t), () {
        debounce?.cancel();
        debounce = null;
      });
    };
  }

  static Future<void> startUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      throw Exception('url null');
    }
    try {
      final url = Uri.parse(urlString);
      final bool isSul = await launchUrl(
        url,
      );
      if (!isSul) {
        // Get.snackbar('error', 'fail');
        throw Exception('fail');
      }
    } catch (e) {
      rethrow;
      // Get.snackbar('error', e.toString());
    }
  }

  static void hideKeyboard(BuildContext context) {
    //FocusScope.of(context).requestFocus(FocusNode())
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
