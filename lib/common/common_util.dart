import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
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

  static Future<void> openUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      Get.log('url is invalid', isError: true);
      return;
    }
    try {
      final url = Uri.parse(urlString);
      final bool isSul = await launchUrl(
        url,
      );
      if (!isSul) {
        Get.log('open url failed', isError: true);
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  static Future<void> sendEmail() async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'support@interactica.ai', // 目标邮件地址
      );
      // 检查是否能够启动邮件客户端
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'Could not launch $emailLaunchUri';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static void hideKeyboard(BuildContext context) {
    //FocusScope.of(context).requestFocus(FocusNode())
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static String formatTime(int time) {
    if (time <= 0) {
      return '';
    }
    final format = DateFormat('dd-MM-yyyy');
    return format.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}
