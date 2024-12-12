import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/request.dart';
import 'package:video_ai/common/file_util.dart';
import 'package:video_ai/controllers/main_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/models/example_model.dart';
import 'package:video_ai/widgets/loading_widget.dart';

import '../common/aws_utils.dart';
import '../models/parameter_model.dart';
import 'mine_controller.dart';

class OldCreateController extends GetxController {
  RxString prompt = "".obs;
  Rxn<ExampleModel> curEffects = Rxn(null);
  RxInt curTabIndex = 0.obs;
  RxList<ExampleModel> effectsList = RxList();

  RxList<ExampleModel> promptItems = RxList();
  Rxn<String> imagePath = Rxn(null);
  RxBool scrollToTop = false.obs;

  final ratioList = [
    ParameterModel(
        name: "16:9", value: "16:9", icon: "assets/images/ic_ratio_16_9.png"),
    ParameterModel(
        name: "9:16", value: "9:16", icon: "assets/images/ic_ratio_9_16.png"),
    ParameterModel(
        name: "1:1", value: "1:1", icon: "assets/images/ic_ratio_1_1.png"),
  ];
  final durationList = [
    ParameterModel(
        name: "20s", value: 20, icon: "assets/images/ic_clock_white.png"),
    ParameterModel(
        name: "15s", value: 15, icon: "assets/images/ic_clock_white.png"),
    ParameterModel(
        name: "10s", value: 10, icon: "assets/images/ic_clock_white.png"),
    ParameterModel(
        name: "5s", value: 5, icon: "assets/images/ic_clock_white.png"),
  ];
  final resolutionList = [
    // ParameterModel(
    //     name: "1080p",
    //     value: 1080,
    //     icon: "assets/images/ic_resolution_1080.png"),
    ParameterModel(
        name: "720p", value: 720, icon: "assets/images/ic_resolution_720.png"),
    ParameterModel(
        name: "480p", value: 480, icon: "assets/images/ic_resolution_480.png"),
  ];

  late Rx<ParameterModel> curRatio;
  late Rx<ParameterModel> curDuration;
  late Rx<ParameterModel> curResolution;

  @override
  void onInit() {
    curRatio = Rx<ParameterModel>(ratioList[ratioList.length - 1]);
    curDuration = Rx<ParameterModel>(durationList[durationList.length - 1]);
    curResolution =
        Rx<ParameterModel>(resolutionList[resolutionList.length - 1]);
    super.onInit();
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
        (data as List).map((record) => ExampleModel.fromJson(record)).toList();
  }

  void selectEffects(ExampleModel effects, {int index = 0}) {
    if (index == 0) {
      prompt.value = effects.description ?? "";
    } else {
      curEffects.value = effects;
    }
    scrollToTop.value = true;
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
      hasEffects = result != null;
    }
    if (hasEffects || inputImageUrl?.isNotEmpty == true) {
      curTabIndex.value = 1;
    } else {
      curTabIndex.value = 0;
    }
    prompt.value = newPrompt;
    scrollToTop.value = true;
  }

  Future<void> getEffectsTags() async {
    try {
      final res = await Request.getEffectsTags();
      final resList = res.map((e) => ExampleModel.fromJson(e)).toList();
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
  Future<bool> aiGenerate(String prompt, String? imagePath, int? effectId,
      {String? ratio, int? resolution, int? duration}) async {
    Get.log(
        "prompt: $prompt -- imagePath: $imagePath  effectId: $effectId  ratio: $ratio  resolution: $resolution  duration: $duration");
    try {
      Get.dialog(const LoadingWidget(), barrierDismissible: false);
      String? imageUrl;
      if (imagePath?.isNotEmpty == true) {
        if (RegExp(r'^https?://').hasMatch(imagePath!)) {
          imageUrl = imagePath;
        } else {
          File compressFile = await FileUtil.compressImage(imagePath);
          imageUrl = await AwsUtils.uploadByFile(compressFile);
          if (imageUrl.isEmpty) {
            Fluttertoast.showToast(msg: 'imageUploadFailed'.tr);
            Get.log('图片上传失败');
            return false;
          }
        }
      }
      final res = await Request.aiGenerate(
          prompt, imageUrl, effectId, ratio, resolution, duration, 1);
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

  // 获取分数的函数
  int getScore() {
    final resolution = curResolution.value.value;
    final ratio = curRatio.value.value;
    int duration = curDuration.value.value;
    int durationNum = duration ~/ 5;
    if (resolution == 480) {
      return (ratio == '1:1' ? 10 : 15) * durationNum;
    } else if (resolution == 720) {
      return (ratio == '1:1' ? 20 : 30) * durationNum;
    } else if (resolution == 1080) {
      return (ratio == '1:1' ? 50 : 100) * durationNum;
    } else {
      return 10;
    }
  }
}
