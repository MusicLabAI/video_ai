import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/dialogs.dart';

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
        path: 'support@superinteractica.ai', // 目标邮件地址
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
    final format = DateFormat('dd/MM/yyyy');
    return format.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static Future<String?> pickUpImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return null;
      }
        String ext = extension(pickedFile.path);
        if (ext == ".gif") {
          Fluttertoast.showToast(msg: 'unsupportedImageFormat'.tr);
          return null;
        }
        return pickedFile.path;
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        Get.dialog(getRequestPermissionDialog('photoLibraryRequestText'.tr));
      } else {
        Get.log('PlatformException: $e', isError: true);
      }
      return null;
    } catch (e) {
      Get.log('Error picking image: $e', isError: true);
      return null;
    }
  }
}
