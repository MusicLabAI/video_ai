import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/request.dart';
import 'package:video_ai/models/effects_model.dart';
import 'package:video_ai/widgets/loading_dialog.dart';

import '../common/aws_utils.dart';

class CreateController extends GetxController {
  RxString prompt = "".obs;
  Rxn<EffectsModel> curEffects = Rxn(null);
  RxInt curTabIndex = 0.obs;
  RxList<EffectsModel> effectsList = RxList();
  RxBool showEffectsDialog = false.obs;
  RxBool isHomeScrolling = false.obs;

  @override
  onInit() {
    super.onInit();
    getEffectsTags();
  }

  /// 复用
  void reuseCurrent(String newPrompt, int? newEffectId) {
    prompt.value = newPrompt;
    if (newEffectId == null) {
      curEffects.value = null;
    } else {
      final result = effectsList.firstWhereOrNull((effectsModel) {
        return effectsModel.id == newEffectId;
      });
      curEffects.value = result;
      if (result != null) {
        curTabIndex.value = 0;
      }
    }
  }

  Future<void> getEffectsTags() async {
    try {
      final res = await Request.getEffectsTags();
      final resList = res.map((e) => EffectsModel.fromJson(e)).toList();
      effectsList.value = resList;
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.log("Model.fromJson error ${e.toString()}");
      effectsList.value = [];
    }
  }

  Future<bool> aiGenerate(String prompt, File? imageFile, int? effectId) async {
    try {
      Get.dialog(const LoadingDialog());
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await AwsUtils.uploadByFile(imageFile);
        if (imageUrl.isEmpty) {
          Fluttertoast.showToast(msg: 'imageUploadFailed'.tr);
          Get.log('图片上传失败');
          return false;
        }
      }
      final res = await Request.aiGenerate(prompt, imageUrl, effectId);
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
