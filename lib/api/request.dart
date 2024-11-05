import 'package:advertising_id/advertising_id.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/record_model.dart';
import 'dio.dart';

class Request {
  static const String _userinfo = '/videoLab/user/detail';
  static const String _userDelete = '/videoLab/user/delete';
  static const String _uploadToken = '/videoLab/remoteFile/uploadToken';
  static const String _aiGenerate = '/videoLab/aiGenerate';
  static const String _getConfig = '/videoLab/common/getConfig';
  static const String _getRecords = '/videoLab/aiGenerate/list';
  static const String _oneClickLogin = '/videoLab/user/oneClickLogin';
  static const String _recommendPrompt = '/videoLab/recommendPrompt/list';
  static const String _historyByIds = '/videoLab/aiGenerate/historyByIds';

  /// telegram_group\email
  static Future<void> getConfig(
      [List<String> conKey = const ['telegram_group', 'email']]) async {
    return await DioUtil.httpPost(_getConfig, data: {'conKey': conKey});
  }

  static Future<dynamic> getUploadToken() async {
    return await DioUtil.httpGet(_uploadToken);
  }

  /// loginType 5 apple  2 google
  static Future<dynamic> oneClickLogin(String uid, String email, int loginType) async {
    return await DioUtil.httpPost(_oneClickLogin,
        data: {'uniqueId': uid, 'email': email, 'loginType': loginType});
  }

  static Future<dynamic> aiGenerate(String prompt, String? inputImageUrl) async {
    return await DioUtil.httpPost(_aiGenerate,
        data: {'prompt': prompt, 'inputImageUrl': inputImageUrl});
  }

  static Future<List<RecordModel>> historyByIds(
      {required List<int> ids}) async {
    List res = await DioUtil.httpPost(_historyByIds, data: {"ids": ids});
    try {
      return res.map((e) => RecordModel.fromJson(e)).toList();
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar('Model.fromJson error', e.toString());
      rethrow;
    }
  }

  static Future<dynamic> deleteRecord(int id) async {
    return await DioUtil.httpDelete("$_aiGenerate/$id", allData: true);
  }

  static Future<dynamic> userinfo() async {
    return await DioUtil.httpGet(_userinfo);
  }

  static Future<void> userDelete() async {
    return await DioUtil.httpPost(_userDelete, data: {});
  }

  static Future<dynamic> getRecords(int pageNum) async {
    return await DioUtil.httpGet(_getRecords,
        allData: true, parameters: {'pageNum': pageNum, 'pageSize': 20});
  }

  static Future<dynamic> getRecommendPrompt() async {
    return await DioUtil.httpGet(_recommendPrompt);
  }
}
