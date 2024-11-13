import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/dio.dart';
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

  @override
  void initState() {
    super.initState();
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
        child: Stack(
          children: [
            TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _mainCtr.tabController,
              children: const [HomePage(), MinePage()],
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomBottomNavBar(
                  currentIndex: _mainCtr.tabController.index,
                  onTap: (index) {
                    setState(() {
                      _mainCtr.tabController.index = index;
                      if (index == 1) {
                        _mineCtr.retry();
                      }
                    });
                  },
                ))
          ],
        ),
      ),
    );
  }
}
