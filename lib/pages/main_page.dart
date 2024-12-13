import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/dio.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/controllers/main_controller.dart';
import 'package:video_ai/controllers/mine_controller.dart';
import 'package:video_ai/controllers/shop_controller.dart';
import 'package:video_ai/pages/history_page.dart';
import 'package:video_ai/pages/mine_page.dart';
import 'package:video_ai/pages/old_create_page.dart';
import 'package:video_ai/pages/video_list_page.dart';
import 'package:video_ai/widgets/custom_bottom_nav_bar.dart';
import 'package:video_ai/widgets/dialogs.dart';

import '../common/popup_counter.dart';
import '../controllers/create_controller.dart';
import '../controllers/user_controller.dart';
import 'create_page.dart';

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
  Worker? _onceWorker;

  @override
  void initState() {
    super.initState();
    _mainCtr.isCreationLayoutSwitch.value = GlobalData.isCreationLayoutSwitch;
    _mainCtr.parseJumpConfig(GlobalData.jumpConfig);
    _mainCtr.getCommonConfig();
    _mainCtr.tabController =
        TabController(initialIndex: 0, length: 4, vsync: this);
    _mainCtr.tabController.addListener(() {
      setState(() {});
    });
    _createCtr.retry();
    if (DioUtil.token.isBlank != true) {
      _userCtr.getUserInfo();
      _mineCtr.onRefresh();
      _onceWorker = once(_userCtr.userInfo, (userInfo) async {
        final value = _mainCtr.configModel.value?.limitedOfferPopup ?? "2";
        int number = 0;
        try {
          number = int.parse(value);
        } catch (_) {}
        final popupCount = await PopupCounter.getPopupCount();
        Get.log("popupCount : $popupCount --> number : $number");
        if (popupCount < number) {
          bool isYearPlan = !(userInfo.isVip ?? false);
          final list = await ShopController().getShopList(
              isYearPlan
                  ? ShopController.productLimitedOfferProType
                  : ShopController.productLimitedOfferPointType,
              showToast: false);
          if (list?.isNotEmpty ?? false) {
            PopupCounter.incrementPopupCount();
            FireBaseUtil.logEventPopupView(
                isYearPlan ? 'pro_popup' : 'credits_popup');
            Get.dialog(LimitedOfferDialog(
              isYearPlan: isYearPlan,
              shopModel: list![0],
            ));
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _mainCtr.tabController.dispose();
    _onceWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _mainCtr.tabController,
              children: const [
                VideoListPage(),
                CreatePage(),
                HistoryPage(),
                MinePage()
              ],
            ),
          ),
          CustomBottomNavBar(
            currentIndex: _mainCtr.tabController.index,
            onTap: (index) {
              setState(() {
                _mainCtr.tabController.index = index;
                if (index == 0) {
                  CommonUtil.hideKeyboard(context);
                  _createCtr.retry();
                }
                if (index == 1) {
                  _createCtr.retry();
                }
                if (index == 2) {
                  CommonUtil.hideKeyboard(context);
                  _mineCtr.retry();
                }
              });
              FireBaseUtil.logEventPageView(index == 0
                  ? PageName.aiStudioPage
                  : (index == 1 ? PageName.createPage : PageName.historyPage));
            },
          )
        ],
      ),
    );
  }
}
