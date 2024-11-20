import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/dio.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/controllers/main_controller.dart';
import 'package:video_ai/controllers/mine_controller.dart';
import 'package:video_ai/pages/home_page.dart';
import 'package:video_ai/pages/mine_page.dart';
import 'package:video_ai/widgets/custom_bottom_nav_bar.dart';

import '../controllers/user_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final MainController _mainCtr = Get.find();
  final UserController _userCtr = Get.find();
  final MineController _mineCtr = Get.find();
  final CreateController _createCtr = Get.find();

  @override
  void initState() {
    super.initState();
    _mainCtr.isCreationLayoutSwitch.value = GlobalData.isCreationLayoutSwitch;
    _mainCtr.getCommonConfig();
    _mainCtr.tabController = TabController(length: 2, vsync: this);
    _mainCtr.tabController.addListener(() {
      setState(() {});
    });
    if (DioUtil.token.isBlank != true) {
      _userCtr.getUserInfo();
      _mineCtr.onRefresh();
    }
  }

  @override
  void dispose() {
    _mainCtr.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _mainCtr.tabController,
                children: const [HomePage(), MinePage()],
              ),
            ),
            CustomBottomNavBar(
                  currentIndex: _mainCtr.tabController.index,
                  onTap: (index) {
                    setState(() {
                      _mainCtr.tabController.index = index;
                      if (index == 0) {
                        _createCtr.retry();
                      }
                      if (index == 1) {
                        CommonUtil.hideKeyboard(context);
                        _mineCtr.retry();
                      }
                    });
                    FireBaseUtil.logEventPageView(index == 0 ? 'HomePage' : 'MinePage');
                  },
                )
          ],
        ),
      ),
    );
  }
}
