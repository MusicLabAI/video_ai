import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/controllers/main_controller.dart';
import 'package:video_ai/controllers/mine_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/models/record_model.dart';
import 'package:video_ai/pages/settings_page.dart';
import 'package:video_ai/pages/video_detail_page.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/dialogs.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  final MainController _mainCtr = Get.find<MainController>();
  final CreateController _createCtr = Get.find<CreateController>();
  final MineController _mineCtr = Get.find<MineController>();
  final UserController _userCtr = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'profile'.tr,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeightExt.semiBold),
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  Get.to(() => const SettingsPage());
                  FireBaseUtil.logEventButtonClick('history_page', 'mine_button');
                },
                icon: Image.asset(
                  'images/icon/ic_user.png',
                  width: 24,
                  height: 24,
                ))
          ],
        ),
        Expanded(
            child: Obx(
          () => !_userCtr.isLogin.value
              ? _unLoginView
              : _mineCtr.dataList.isEmpty
                  ? _emptyRecordView
                  : EasyRefresh(
                      onRefresh: () {
                        _mineCtr.onRefresh();
                      },
                      onLoad: () {
                        _mineCtr.onLoad();
                      },
                      child: _getGridView(_mineCtr.dataList, context)),
        ))
      ],
    );
  }

  Widget get _emptyRecordView {
    return Center(
      child: GestureDetector(
        onTap: () {
          _mainCtr.tabController.index = 0;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/img_empty_video.png',
              width: 160,
              height: 160,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16),
              child: Text(
                'noRecordsAndCreate'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14,
                    color: UiColors.c6A696F,
                    fontWeight: FontWeightExt.semiBold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget get _unLoginView {
    return Center(
      child: GestureDetector(
        onTap: () {
          _userCtr.showLogin();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16),
              child: Text(
                'pleaseLogIn'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14,
                    color: UiColors.c6A696F,
                    fontWeight: FontWeightExt.semiBold),
              ),
            ),
            CustomButton(
              text: 'logIn'.tr,
              textColor: UiColors.cDBFFFFFF,
              bgColors: const [UiColors.c7631EC, UiColors.cA359EF],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              textSize: 16,
            )
          ],
        ),
      ),
    );
  }

  Widget _getGridView(List<RecordModel> items, BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0),
        padding: const EdgeInsets.all(10),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final recordItem = items[index];

          return Container(
            decoration: BoxDecoration(
                color: UiColors.c1B1B1F,
                borderRadius: BorderRadius.circular(16)),
            child: _getItemView(recordItem),
          );
        });
  }

  Widget _getItemView(RecordModel recordItem) {
    switch (recordItem.status) {
      case 2:
        return _productionSucceed(
          recordItem,
        );
      case 3:
        return _productionFailed(recordItem);
      default:
        return const _ProductionProgressView();
    }
  }

  //删除
  Future<void> _deleteItem(RecordModel recordItem) async {
    Get.dialog(CustomDialog(
      title: 'confirmDeletion'.tr,
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Image.asset(
          'images/icon/ic_delete_big.png',
          width: 70,
          height: 70,
        ),
      ),
      confirmText: 'delete'.tr,
      cancelText: 'cancel'.tr,
      onConfirm: () async {
        Get.back();
        _mineCtr.delete(recordItem.id);
      },
    ));
    FireBaseUtil.logEventButtonClick('history_page', 'delete_video_button', popupName: 'delete_video_popup');
  }

  Widget _productionSucceed(RecordModel recordItem) {
    return GestureDetector(
      onTap: () async {
        var data = await Get.to(() => VideoDetailPage(
              recordModel: recordItem,
            ));
        if (data is RecordModel) {
          _createCtr.reuseCurrent(data.prompt ?? '', data.inputImageUrl, data.effectId);
          _mainCtr.tabController.index = 0;
        }
      },
      child: Stack(children: [
        if (recordItem.thumbnailUrl?.isNotEmpty ?? false)
          Positioned.fill(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: recordItem.thumbnailUrl!,
                  fit: BoxFit.cover,
                )),
          ),
        _delete(onTap: () {
          _deleteItem(recordItem);
        }),
      ]),
    );
  }

  Widget _productionFailed(RecordModel recordItem) {
    return GestureDetector(
      onTap: () {
        if (recordItem.failureCode == 1511) {
          Fluttertoast.showToast(msg: recordItem.failureReason ?? '');
        }
      },
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 40,
            child: Image.asset(
              'images/icon/ic_production_failed.png',
              width: 60,
              height: 60,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'productionFailed'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeightExt.semiBold,
                      fontSize: 12,
                      color: UiColors.cDBFFFFFF),
                ),
                const SizedBox(height: 2),
                Text(
                  'creditsHaveBeenRefunded'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeightExt.semiBold,
                      fontSize: 10,
                      color: UiColors.c99FFFFFF),
                )
              ],
            ),
          ),
          _delete(
            onTap: () {
              _deleteItem(recordItem);
            },
            bgColor: UiColors.c99000000,
          ),
        ],
      ),
    );
  }

  Widget _delete({required Function() onTap, Color? bgColor}) {
    return Positioned(
        right: 10,
        top: 10,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: bgColor ?? UiColors.c99000000,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              'images/icon/ic_delete_white.png',
              width: 16,
              height: 16,
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class _ProductionProgressView extends StatefulWidget {
  const _ProductionProgressView();

  @override
  State<_ProductionProgressView> createState() =>
      _ProductionProgressViewState();
}

class _ProductionProgressViewState extends State<_ProductionProgressView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // 持续重复动画
  }

  @override
  void dispose() {
    _controller.dispose(); // 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotationTransition(
            turns: _controller,
            child: Image.asset(
              'images/icon/ic_in_production.png',
              width: 60,
              height: 60,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 8),
            child: Text(
              'inProgress'.tr,
              style: const TextStyle(
                  fontSize: 12,
                  color: UiColors.cDBFFFFFF,
                  fontWeight: FontWeightExt.semiBold),
            ),
          ),
          Text(
            'productionTips'.tr,
            style: const TextStyle(color: UiColors.c61FFFFFF, fontSize: 10),
          )
        ],
      ),
    );
  }
}
