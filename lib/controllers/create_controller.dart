import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/request.dart';
import 'package:video_ai/controllers/main_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/models/effects_model.dart';
import 'package:video_ai/widgets/loading_widget.dart';

import '../common/aws_utils.dart';
import '../models/prompt_model.dart';
import 'mine_controller.dart';

class CreateController extends GetxController {
  RxString prompt = "".obs;
  Rxn<EffectsModel> curEffects = Rxn(null);
  RxInt curTabIndex = 0.obs;
  RxList<EffectsModel> effectsList = RxList();

  RxList<EffectsModel> promptItems = RxList();
  Rxn<String> imagePath = Rxn(null);

  @override
  onInit() {
    super.onInit();
    getRecommendPrompt();
    getEffectsTags();
  }

  void retry() {
    if (promptItems.isEmpty) {
      getRecommendPrompt();
    }
    if (effectsList.isEmpty) {
      getEffectsTags();
    }
  }

  Future<void> getRecommendPrompt() async {
    final data = await Request.getRecommendPrompt();
    promptItems.value =
        (data as List).map((record) => EffectsModel.fromJson(record)).toList();
  }

  void selectEffects(EffectsModel effects, {int index = 0}) {
    if (index == 0) {
      curEffects.value = effects;
    } else {
      prompt.value = effects.tag ?? "";
    }
    curTabIndex.value = index;
  }

  /// 复用
  void reuseCurrent(String newPrompt, String? inputImageUrl, int? newEffectId) {
    if (inputImageUrl != null && inputImageUrl.isNotEmpty) {
      imagePath.value = inputImageUrl;
    }
    bool hasEffects = false;
    if (newEffectId == null) {
      curEffects.value = null;
    } else {
      final result = effectsList.firstWhereOrNull((effectsModel) {
        return effectsModel.id == newEffectId;
      });
      curEffects.value = result;
      if (result != null) {
        hasEffects = true;
      }
    }
    if (hasEffects || inputImageUrl?.isNotEmpty == true) {
      curTabIndex.value = 0;
    }
    prompt.value = newPrompt;
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

  ///如果有复用的图片，使用复用的图片
  Future<bool> aiGenerate(String prompt, String? imagePath, int? effectId) async {
    Get.log("prompt: $prompt -- imagePath: $imagePath  effectId: $effectId");
    try {
      Get.dialog(const LoadingWidget(), barrierDismissible: false);
      String? imageUrl;
      if (imagePath?.isNotEmpty == true) {
        if (RegExp(r'^https?://').hasMatch(imagePath!)) {
          imageUrl = imagePath;
        } else {
          imageUrl = await AwsUtils.uploadByFile(File(imagePath));
          if (imageUrl.isEmpty) {
            Fluttertoast.showToast(msg: 'imageUploadFailed'.tr);
            Get.log('图片上传失败');
            return false;
          }
        }
      }
      final res = await Request.aiGenerate(prompt, imageUrl, effectId);
      if (res != null) {
        Get.find<UserController>().getUserInfo();
        Get.find<MainController>().tabController.index = 2;
        Get.find<MineController>().onRefresh();
      }
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
