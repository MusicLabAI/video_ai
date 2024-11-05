import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/main_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/models/record_model.dart';
import 'package:video_ai/pages/settings_page.dart';
import 'package:video_ai/pages/video_detail_page.dart';
import 'package:video_ai/widgets/dialogs.dart';

import '../api/request.dart';
import '../widgets/loading_dialog.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin{
  final MainController _mainCtr = Get.find<MainController>();

  List<RecordModel> _dataList = [];
  List<int> _ids = [];
  int _pageNum = 1;
  bool _isLoading = false;
  bool _isLastPage = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (Get.find<UserController>().isLogin.value) {
      _isLoading = true;
      _onRefresh();
    }
    ever(_mainCtr.refreshRecords, (value) {
      setState(() {
        if (value) {
          _onRefresh();
          _mainCtr.refreshRecords.value = false;
        }
      });
    });
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    if (_ids.isEmpty) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      await queryHistoryByIds();
    });
  }

  Future<void> queryHistoryByIds() async {
    List<RecordModel> list = await Request.historyByIds(ids: _ids);
    if (list.isNotEmpty) {
      setState(() {
        for (var value in list) {
          // 找到 ID 相同的记录并替换
          final index = _dataList.indexWhere((record) => record.id == value.id);
          if (index != -1) {
            _dataList[index] = value; // 替换值
          }
        }
      });
    }
    updatePollingIds();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _onRefresh() async {
    _isLastPage = false;
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    _pageNum = 1;
    final res = await Request.getRecords(_pageNum);
    _isLastPage = res['isLastPage'];
    final datas = (res['data'] as List)
        .map((record) => RecordModel.fromJson(record))
        .toList();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _dataList = datas;
      });
    }
    updatePollingIds();
  }

  void updatePollingIds() {
    _ids = _dataList.where((record) => !record.isCompleted()).map((record) => record.id).toList();
    startTimer();
  }

  Future<void> _onLoad() async {
    if (_isLastPage) return;
    _pageNum++;
    final res = await Request.getRecords(_pageNum);
    _isLastPage = res['lastPage'];
    final datas = (res['data'] as List)
        .map((record) => RecordModel.fromJson(record))
        .toList();
    setState(() {
      _dataList.addAll(datas);
    });
    updatePollingIds();
  }

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
                },
                icon: Image.asset(
                  'images/icon/ic_settings.png',
                  width: 24,
                  height: 24,
                ))
          ],
        ),
        Expanded(
            child: _dataList.isEmpty
                ? _emptyRecordView
                : EasyRefresh(
                    onRefresh: () {
                      _onRefresh();
                    },
                    onLoad: () {
                      _onLoad();
                    },
                    child: _getGridView(_dataList, context)))
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'emptyRecordsTips'.tr,
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
                color: UiColors.c131313,
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
    if (recordItem.id == null) {
      return;
    }
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
        Get.dialog(const LoadingDialog());
        final result = await Request.deleteRecord(recordItem.id!);
        if (result != null && result['code'] == 0) {
          _onRefresh();
        }
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      },
    ));
  }

  Widget _productionSucceed(RecordModel recordItem) {
    return InkWell(
      onTap: () async {
        var data = await Get.to(() => VideoDetailPage(
              recordModel: recordItem,
            ));
        if (data is RecordModel) {
          _mainCtr.prompt.value = data.prompt ?? '';
          _mainCtr.tabController.index = 0;
        }
      },
      child: Stack(children: [
        if (recordItem.thumbnailUrl?.isNotEmpty ?? false)
          Positioned.fill(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  recordItem.thumbnailUrl!,
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
    return Stack(
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
                    color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                'creditsHaveBeenRefunded'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeightExt.semiBold,
                    fontSize: 10,
                    color: UiColors.cB3B3B3),
              )
            ],
          ),
        ),
        _delete(
          onTap: () {
            _deleteItem(recordItem);
          },
          bgColor: UiColors.c66000000,
        ),
      ],
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
  const _ProductionProgressView({super.key});

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
          const SizedBox(
            height: 6,
          ),
          Text(
            'inProgress'.tr,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeightExt.semiBold),
          )
        ],
      ),
    );
  }
}
