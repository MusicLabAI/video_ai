import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/loading_dialog.dart';

class FileUtil {
  static Future<void> downlo2ad(String url,
      {Future<void> Function(String path)? extraOperate}) async {
    if (!(await _checkPermission())) {
      return;
    }

    Get.dialog(const LoadingDialog(), barrierDismissible: false);
    var appDocDir = '';
    if (GetPlatform.isIOS) {
      appDocDir = (await getApplicationDocumentsDirectory()).path;
    } else {
      appDocDir = ((await getExternalStorageDirectory()) ??
              (await getApplicationDocumentsDirectory()))
          .path;
    }
    String savePath = '$appDocDir/${url.split('/').last}';
    if (await File(savePath).exists()) {
      if (extraOperate != null) {
        extraOperate.call(savePath);
        Get.back();
        return;
      }
      Get.back();
      if (GetPlatform.isAndroid) {
        Fluttertoast.showToast(msg: '${'fileSavedTo'.tr}"$savePath"');
      } else {
        Fluttertoast.showToast(msg: '${'fileSavedTo'.tr}"${'iosFilePath'.tr}"');
      }
      return;
    }
    try {
      final resp = await Dio().download(
        url,
        savePath,
        // onReceiveProgress: onReceiveProgress,
        options: Options(
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );
      if (resp.statusCode == 200) {
        Get.log('下载成功');
        if (extraOperate != null) {
          extraOperate.call(savePath);
          Get.back();
          return;
        }
        Get.back();
        Fluttertoast.showToast(msg: 'downloadComplete'.tr);
      } else {
        Get.back();
        Fluttertoast.showToast(msg: 'downloadFailed'.tr);
        Get.log('下载失败');
      }
      /* ,queryParameters: queryParams,cancelToken: cancelToken,onReceiveProgress: (count,total){
        print("-------------------->下载进度：${count/total}");
      }*/
    } catch (e) {
      Get.back();
      Get.log(e.toString());
      rethrow;
    }
  }

  static Future<bool> _checkPermission() async {
    if (GetPlatform.isIOS) {
      return true;
    }

    return false;
  }

  static Future<File?> imageToFile(Image image) async {
    final appDocDir = (await getApplicationCacheDirectory()).path;
    final imgPath = '$appDocDir/${DateTime.now().microsecondsSinceEpoch}.jpeg';
    final imageBytes = encodeJpg(image, quality: 60);
    // final Uint8List? imageBytes = encodeNamedImage(imgPath, image);
    // if (imageBytes == null) return null;
    final file = File(imgPath);
    return await file.writeAsBytes(imageBytes);
  }

  static Future<File?> listToFile(Uint8List list) async {
    final appDocDir = (await getApplicationCacheDirectory()).path;
    final imgPath = '$appDocDir/${DateTime.now().microsecondsSinceEpoch}.jpeg';
    final file = File(imgPath);
    return await file.writeAsBytes(list);
  }

  static Future<void> saveFile(
      {required String fileName,
      String? url,
      File? file,
      Uint8List? bytes}) async {
    file ??= (await downloadOnly(url));
    if (file == null && bytes == null) return;
    final outputFile = await FilePicker.platform.saveFile(
      fileName: fileName,
      bytes: bytes ?? file!.readAsBytesSync(),
    );
    if (outputFile != null) {
      file?.delete();
      Fluttertoast.showToast(msg: 'downloadComplete'.tr);
    }
  }

  static Future<File?> downloadOnly(String? url) async {
    if (url == null) return null;
    Get.dialog(const LoadingDialog(), barrierDismissible: false);
    final savePath =
        '${(await getApplicationCacheDirectory()).path}/${url.split('/').last}';
    final File file = File(savePath);
    if (await file.exists()) {
      Get.back();
      return file;
    }
    try {
      final resp = await Dio().download(
        url,
        savePath,
        // onReceiveProgress: onReceiveProgress,
        options: Options(
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );
      if (resp.statusCode == 200) {
        Get.back();
        return file;
      } else {
        Get.back();
        Fluttertoast.showToast(msg: 'downloadFailed'.tr);
        return null;
      }
      /* ,queryParameters: queryParams,cancelToken: cancelToken,onReceiveProgress: (count,total){
        print("-------------------->下载进度：${count/total}");
      }*/
    } catch (e) {
      Get.back();
      Get.log(e.toString());
      Fluttertoast.showToast(msg: 'serverError'.tr);
      rethrow;
    }
  }

  static String getFileNameFromUrl(String url) {
    // 使用 Uri 类将 URL 解析为路径的一部分
    Uri uri = Uri.parse(url);
    return uri.pathSegments.last; // 获取最后一个路径片段作为文件名
  }

  
}
