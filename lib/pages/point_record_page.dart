import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/api/request.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/main_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';
import 'package:video_ai/widgets/custom_button.dart';


class PointRecordPage extends StatefulWidget {
  const PointRecordPage({super.key});

  @override
  State<PointRecordPage> createState() => _PointRecordPageState();
}

class _PointRecordPageState extends State<PointRecordPage> {
  final UserController _userCtr = Get.find<UserController>();
  List _dataList = [];
  int _pageNum = 1;
  bool _isLoading = false;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    _onRefresh();
    FireBaseUtil.logEventPageView('credits_page');
  }

  Future<void> _onRefresh() async {
    _isLastPage = false;
    setState(() {
      _isLoading = true;
    });
    _pageNum = 1;
    try {
      final res = await Request.getPointRecordList(pageNum: _pageNum);
      _isLastPage = res['isLastPage'];
      setState(() {
        _isLoading = false;
        _dataList = res['data'];
      });
    } catch(e) {
      setState(() {
        _isLoading = false;
        _dataList = [];
      });
    }
  }

  Future<void> _onLoad() async {
    if (_isLastPage) return;
    _pageNum++;
    final res = await Request.getPointRecordList(pageNum: _pageNum);
    _isLastPage = res['isLastPage'];
    setState(() {
      _dataList.addAll(res['data']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Image.asset('images/icon/ic_back.png'),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            CustomButton(
              onTap: () => Get.to(() => (_userCtr.userInfo.value.isVip ?? false)
                  ? const PointPurchasePage()
                  : const ProPurchasePage()),
              text: "${_userCtr.userInfo.value.point ?? 0}",
              textColor: UiColors.c99FFFFFF,
              border: Border.all(color: UiColors.c30333F),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              leftIcon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  'images/icon/ic_diamonds.png',
                  width: 21,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        body: SafeArea(
          child: _dataList.isEmpty
              ? _emptyView()
              : EasyRefresh(
                  onRefresh: () {
                    _onRefresh();
                  },
                  onLoad: () {
                    _onLoad();
                  },
                  child: ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) {
                      return _buildItem(_dataList[index]);
                    },
                  )),
        ));
  }

  Widget _buildItem(dynamic item) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
      decoration: BoxDecoration(
          color: UiColors.c23242A, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                typeLocal(item['type']),
                style: TextStyle(
                    color: UiColors.cD0D0D0,
                    fontSize: 14,
                    fontWeight: FontWeightExt.medium),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                CommonUtil.formatTime(item['changeTime']),
                style: TextStyle(
                    color: UiColors.c848484,
                    fontSize: 12,
                    fontWeight: FontWeightExt.medium),
              ),
            ],
          )),
          Text(
            "${item['price']} ${'Credits'.tr}",
            style: TextStyle(
                color: UiColors.cD0D0D0,
                fontSize: 14,
                fontWeight: FontWeightExt.medium),
          )
        ],
      ),
    );
  }

  Widget _emptyView() {
    if (_isLoading) {
      return const SizedBox();
    }
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'images/icon/img_no_records.png',
          width: 100,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 30),
          child: Text(
            'noRecordsTips'.tr,
            style: TextStyle(
                color: UiColors.c6A696F,
                fontSize: 14,
                fontWeight: FontWeightExt.medium),
          ),
        ),
        Text(
          'goGenerateTips'.tr,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeightExt.semiBold),
        ),
        const SizedBox(
          height: 30,
        ),
        CustomButton(
          onTap: () {
            Get.until((route) => Get.currentRoute == '/');
            Get.find<MainController>().tabController.index = 0;
          },
          text: 'generate'.tr,
          textColor: Colors.white,
          textSize: 14,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 11),
          borderRadius: BorderRadius.circular(26),
          bgColor: UiColors.cA754FC,
        )
      ],
    ));
  }

  String typeLocal(int type) {
    switch (type) {
      case 0:
        return 'pointHistoryType0'.tr;
      case 1:
        return 'pointHistoryType1'.tr;
      case 2:
        return 'pointHistoryType2'.tr;
      case 3:
        return 'pointHistoryType3'.tr;
      case 4:
        return 'pointHistoryType4'.tr;
      default:
        return '';
    }
  }
}
