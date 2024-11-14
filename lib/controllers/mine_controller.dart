import 'dart:async';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:video_ai/controllers/user_controller.dart';

import '../api/request.dart';
import '../models/record_model.dart';
import '../widgets/loading_dialog.dart';

class MineController extends GetxController {
  final RxList<RecordModel> dataList = <RecordModel>[].obs;
  List<int> _ids = [];
  int _pageNum = 1;
  bool _isLoading = false;
  bool _isLastPage = false;
  bool networkError = false;
  Timer? _timer;

  @override
  void onClose() {
    super.onClose();
    stopTimer();
  }

  void startTimer() {
    _timer ??= Timer.periodic(const Duration(seconds: 20), (timer) async {
      await queryHistoryByIds();
    });
  }

  Future<void> queryHistoryByIds() async {
    List<RecordModel> list = await Request.historyByIds(ids: _ids);
    if (list.isNotEmpty) {
      for (var value in list) {
        // 找到 ID 相同的记录并替换
        final index = dataList.indexWhere((record) => record.id == value.id);
        if (index != -1) {
          dataList[index] = value; // 替换值
        }
      }
    }
    updatePollingIds();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void retry() {
    if (_isLoading || !networkError) {
      return;
    }
    Get.log('重试了');
    onRefresh();
  }

  Future<void> onRefresh() async {
    if (!Get.find<UserController>().isLogin.value) {
      dataList.value = [];
      stopTimer();
      return;
    }
    try {
      _isLastPage = false;
      _isLoading = true;
      _pageNum = 1;
      final res = await Request.getRecords(_pageNum);
      _isLastPage = res['isLastPage'];
      final datas = (res['data'] as List)
          .map((record) => RecordModel.fromJson(record))
          .toList();
      _isLoading = false;
      dataList.value = datas;
      networkError = false;
      updatePollingIds();
    } catch(e) {
      networkError = true;
      _isLoading = false;
    }
  }

  void updatePollingIds() {
    _ids = dataList
        .where((record) => !record.isCompleted())
        .map((record) => record.id)
        .toList();
    if (_ids.isEmpty) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  Future<void> onLoad() async {
    if (_isLastPage) return;
    int newPage = _pageNum++;
    final res = await Request.getRecords(newPage);
    _pageNum = newPage;
    _isLastPage = res['lastPage'];
    final datas = (res['data'] as List)
        .map((record) => RecordModel.fromJson(record))
        .toList();
    dataList.addAll(datas);
    updatePollingIds();
  }

  Future<void> delete(int id) async {
    Get.dialog(const LoadingDialog());
    final result = await Request.deleteRecord(id);
    if (result != null && result['code'] == 0) {
      onRefresh();
    }
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
