import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/dio.dart';
import 'package:video_ai/controllers/main_controller.dart';
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
  MainController mainController = Get.find();
  UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    mainController.tabController = TabController(length: 2, vsync: this);
    mainController.tabController.addListener(() {
      setState(() {});
    });
    if (DioUtil.token.isBlank != true) {
      userController.getUserInfo();
    }
  }

  @override
  void dispose() {
    mainController.tabController.dispose();
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
              controller: mainController.tabController,
              children: const [HomePage(), MinePage()],
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomBottomNavBar(
                  currentIndex: mainController.tabController.index,
                  onTap: (index) {
                    setState(() {
                      mainController.tabController.index = index;
                    });
                  },
                ))
          ],
        ),
      ),
    );
  }
}
