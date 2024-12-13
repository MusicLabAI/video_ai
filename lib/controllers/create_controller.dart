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
import '../models/prompt_model.dart';
import 'mine_controller.dart';

class CreateController extends GetxController {
  RxString prompt = "".obs;
  RxList<ExampleModel> effectsList = RxList();

  RxList<ExampleModel> promptItems = RxList();
  Rxn<String> imagePath = Rxn(null);

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
    ParameterModel(
        name: "1080p",
        value: 1080,
        icon: "assets/images/ic_resolution_1080.png"),
    ParameterModel(
        name: "720p", value: 720, icon: "assets/images/ic_resolution_720.png"),
    ParameterModel(
        name: "480p", value: 480, icon: "assets/images/ic_resolution_480.png"),
  ];
  final variationsList = [
    ParameterModel(
        name: "4 Videos",
        value: 4,
        littleName: "4v",
        icon: "assets/images/ic_variations_4.png"),
    ParameterModel(
        name: "2 Videos",
        value: 2,
        littleName: "2v",
        icon: "assets/images/ic_variations_2.png"),
    ParameterModel(
        name: "1 Videos",
        value: 1,
        littleName: "1v",
        icon: "assets/images/ic_variations_1.png"),
  ];

  late Rx<ParameterModel> curRatio;
  late Rx<ParameterModel> curDuration;
  late Rx<ParameterModel> curResolution;
  late Rx<ParameterModel> curVariations;

  @override
  void onInit() {
    curRatio = Rx<ParameterModel>(ratioList[1]);
    curDuration = Rx<ParameterModel>(durationList[durationList.length - 1]);
    curResolution =
        Rx<ParameterModel>(resolutionList[resolutionList.length - 1]);
    curVariations =
        Rx<ParameterModel>(variationsList[variationsList.length - 1]);
    super.onInit();
  }

  void updateDuration(bool isEnable){
    for (var item in durationList) {
      if (item.value > 10) {
        item.enable = isEnable;
      }
    }
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

  /// 复用
  void reuseCurrent(String newPrompt, {String? inputImageUrl}) {
    if (inputImageUrl != null && inputImageUrl.isNotEmpty) {
      imagePath.value = inputImageUrl;
    }
    prompt.value = newPrompt;
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
  Future<bool> aiGenerate(String prompt, String? imagePath,
      {int? effectId, String? ratio, int? resolution, int? duration, int? num}) async {
    Get.log(
        "prompt: $prompt -- imagePath: $imagePath  effectId: $effectId  ratio: $ratio  resolution: $resolution  duration: $duration num: $num");
    try {
      Get.dialog(const LoadingWidget(canPop: false,), barrierDismissible: false);
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
          prompt, imageUrl, effectId, ratio, resolution, duration, num);
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
    int variations = curVariations.value.value;
    if (resolution == 480) {
      return (ratio == '1:1' ? 10 : 15) * durationNum * variations;
    } else if (resolution == 720) {
      return (ratio == '1:1' ? 20 : 30) * durationNum * variations;
    } else if (resolution == 1080) {
      return (ratio == '1:1' ? 50 : 100) * durationNum * variations;
    } else {
      return 10;
    }
  }
}
