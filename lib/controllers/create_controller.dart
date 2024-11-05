import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/request.dart';
import 'package:video_ai/widgets/loading_dialog.dart';

import '../common/aws_utils.dart';

class CreateController extends GetxController {

  Future<bool> aiGenerate(String prompt, File? imageFile) async {
    try {
      Get.dialog(const LoadingDialog());
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await AwsUtils.uploadByFile(imageFile);
        if (imageUrl.isEmpty) {
          Get.log('图片上传失败');
          return false;
        }
      }
      final res = await Request.aiGenerate(prompt, imageUrl);
      return res != null;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      return false;
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }
}
