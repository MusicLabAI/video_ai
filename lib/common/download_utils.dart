import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';

class DownloadUtils {
  static final Dio _dio = Dio();

  // 下载视频并保存到公共的下载目录
  static Future<String?> downloadVideo(String url, String fileName) async {
    // 请求存储权限，适用于 Android 9 及以下版本
    // if (await _requestPermission()) {
      try {
        String? directoryPath;
        if (Platform.isAndroid) {
          final downloadsDirectory = await getDownloadsDirectory();
          directoryPath = downloadsDirectory?.path;
        } else {
          final tempDir = await getApplicationDocumentsDirectory();
           directoryPath = tempDir.path;
        }
        if (directoryPath != null) {
          String savePath = '$directoryPath/$fileName';
          print(savePath);
          bool fileExists = await File(savePath).exists();
          if (true) {
            // 下载视频
            await _dio.download(
              url,
              savePath,
              onReceiveProgress: (received, total) {
                if (total != -1) {
                  Get.log(
                      'Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
                }
              },
            );
          }
          Get.log('Video downloaded to: $savePath');
          return savePath;
        } else {
          Get.log('Failed to access Downloads directory');
          return null;
        }
      } catch (e) {
        Get.log('Error downloading video: $e');
        return null;
      }
    // } else {
    //   Get.log('Unable to access downloads directory.');
    //   return null;
    // }
  }

  // 请求存储权限
  // static Future<bool> _requestPermission() async {
  //   if (Platform.isAndroid) {
  //     var status = await Permission.storage.status;
  //     if (status.isDenied ||
  //         status.isRestricted ||
  //         status.isPermanentlyDenied) {
  //       status = await Permission.storage.request();
  //     }
  //     return status.isGranted;
  //   }
  //   return true;
  // }

  // static Future<Directory?> getDownloadDirectory() async {
  //   if (Platform.isAndroid) {
  //     final downloadsDir = Directory('/storage/emulated/0/Download');
  //     if (await downloadsDir.exists()) {
  //       return downloadsDir;
  //     } else {
  //       // 如果目录不存在，可以创建
  //       return downloadsDir.create();
  //     }
  //   } else {
  //     // iOS 不支持访问公共的 Downloads 目录
  //     return await getApplicationDocumentsDirectory();
  //   }
  // }
}
