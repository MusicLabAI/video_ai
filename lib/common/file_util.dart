import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import '../widgets/loading_widget.dart';

class FileUtil {
  static Future<void> downlo2ad(String url,
      {Future<void> Function(String path)? extraOperate}) async {
    if (!(await _checkPermission())) {
      return;
    }

    Get.dialog(const LoadingWidget(), barrierDismissible: false);
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

  static Future<File> compressImage(String imagePath) async {
    final file = File(imagePath);
    // 获取图片的原始数据
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(Uint8List.fromList(bytes));
    if (image != null) {
      int fileSize = await file.length();
      if (fileSize <= 500 * 1024) {
        Get.log("无需压缩");
        return File(imagePath);
      }
      // 根据文件大小来设置不同的压缩质量
      int quality = 70; // 默认质量
      if (fileSize > 4 * 1024 * 1024) {
        quality = 50; // 如果文件大于 4MB，降低压缩质量
      } else if (fileSize > 2 * 1024 * 1024) {
        quality = 60; // 如果文件大于 2MB，略微降低压缩质量
      }
      // 使用 image 包将图片压缩并调整质量
      List<int> compressedBytes = img.encodeJpg(image, quality: quality);
      // 创建压缩后的图片文件
      String compressedPath = imagePath.replaceAll('.jpg', '_compressed.jpg');
      File compressedFile = File(compressedPath);
      // 保存压缩后的文件
      await compressedFile.writeAsBytes(compressedBytes);
      Get.log("压缩成功： ${compressedFile.path}");
      // 返回压缩后的文件
      return compressedFile;
    } else {
      Get.log('压缩：解析图片失败，返回原图');
      return File(imagePath);
    }
  }

  // Future<void> compressAndResizeImage(String imagePath) async {
  //   final file = File(imagePath);
  //
  //   // 获取图片的原始宽高
  //   final bytes = await file.readAsBytes();
  //   final image = img.decodeImage(Uint8List.fromList(bytes));
  //
  //   if (image != null) {
  //     int imageWidth = image.width;
  //     int imageHeight = image.height;
  //     int fileSize = await file.length();
  //
  //     print('原始图片宽高: $imageWidth x $imageHeight, 文件大小: $fileSize 字节');
  //
  //     // 如果文件大于 1MB 或者宽高超过 4000px，进行压缩
  //     if (fileSize > 1 * 1024 * 1024 || imageWidth > 4000 || imageHeight > 4000) {
  //       // 按比例缩放，确保最大边不超过 4000px
  //       double aspectRatio = imageWidth / imageHeight;
  //
  //       int newWidth = imageWidth > imageHeight ? 4000 : (4000 * aspectRatio).toInt();
  //       int newHeight = imageHeight > imageWidth ? 4000 : (4000 / aspectRatio).toInt();
  //
  //       // 根据文件大小自动计算压缩质量
  //       int quality = 80; // 默认质量
  //       if (fileSize > 5 * 1024 * 1024) {
  //         quality = 60; // 如果文件大于 5MB，降低压缩质量
  //       } else if (fileSize > 2 * 1024 * 1024) {
  //         quality = 70; // 如果文件大于 2MB，略微降低压缩质量
  //       }
  //
  //       print('压缩质量设定: $quality');
  //
  //       // 使用 FlutterImageCompress 进行压缩和缩放
  //       var result = await FlutterImageCompress.compressWithFile(
  //         file.absolute.path,
  //         quality: quality,  // 质量控制
  //         minWidth: newWidth,  // 缩放后的宽度
  //         minHeight: newHeight,  // 缩放后的高度
  //         rotate: 0,  // 不旋转
  //         format: CompressFormat.jpeg,  // 压缩格式
  //       );
  //
  //       if (result != null) {
  //         // 保存压缩后的文件
  //         File compressedFile = File(imagePath.replaceAll('.jpg', '_compressed.jpg'));
  //         await compressedFile.writeAsBytes(result);
  //         print('图片压缩并缩放成功！');
  //       } else {
  //         print('图片压缩失败');
  //       }
  //     } else {
  //       // 图片无需处理
  //       print('图片尺寸在1MB以内，且宽高在4000px以内，无需处理');
  //     }
  //   } else {
  //     print('无法解码图片');
  //   }
  // }

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
    Get.dialog(const LoadingWidget(), barrierDismissible: false);
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
