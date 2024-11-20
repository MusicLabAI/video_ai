import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_ai/api/request.dart';

import '../common/global_data.dart';

class MainController extends GetxController {
  late TabController tabController;
  RxBool isCreationLayoutSwitch = false.obs;

  Future<void> getCommonConfig() async {
    final config = await Request.getCommonConfig();
    final value = config.creationLayoutSwitch == 1;
    isCreationLayoutSwitch.value = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(GlobalData.KEY_CREATION_LAYOUT_SWITCH, value);
  }
}
