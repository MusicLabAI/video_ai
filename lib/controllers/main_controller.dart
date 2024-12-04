import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_ai/api/request.dart';

import '../common/global_data.dart';
import '../models/config_model.dart';
import '../models/jump_config_model.dart';

class MainController extends GetxController {
  late TabController tabController;
  Rxn<ConfigModel> configModel = Rxn<ConfigModel>();
  RxBool isCreationLayoutSwitch = false.obs;
  Rxn<List<JumpConfigModel>> jumpConfigs = Rxn(null);

  Future<void> getCommonConfig() async {
    final config = await Request.getCommonConfig();
    configModel.value = config;
    parseJumpConfig(config.jumpConfig);
    final value = config.creationLayoutSwitch == "1";
    isCreationLayoutSwitch.value = value;
    GlobalData.isCreationLayoutSwitch = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(GlobalData.KEY_CREATION_LAYOUT_SWITCH, value);
    prefs.setString(GlobalData.KEY_JUMP_CONFIG, config.jumpConfig);
  }

  void parseJumpConfig(String? jumpConfig) {
    try {
      if (jumpConfig?.isEmpty ?? true) {
        jumpConfigs.value = null;
        return;
      }
      List<dynamic> decodedList = json.decode(jumpConfig!);
      List<JumpConfigModel> jumpConfigList = decodedList.map((item) {
        return JumpConfigModel.fromJson(item);
      }).toList();
      jumpConfigs.value = jumpConfigList;
    } catch (e) {
      jumpConfigs.value = null;
    }
  }
}
