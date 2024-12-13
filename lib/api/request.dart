import 'package:get/get.dart';

import '../models/config_model.dart';
import '../models/record_model.dart';
import 'dio.dart';

class Request {
  static const String _userinfo = '/videoAi/user/detail';
  static const String _userDelete = '/videoAi/user/delete';
  static const String _uploadToken = '/videoAi/remoteFile/uploadToken';
  static const String _aiGenerate = '/videoAi/aiGenerate';
  static const String _getRecords = '/videoAi/aiGenerate/list';
  static const String _pointRecordList = '/videoAi/user/pointRecordList';
  static const String _oneClickLogin = '/videoAi/user/oneClickLogin';
  static const String _recommendPrompt = '/videoAi/recommendPrompt/list';
  static const String _historyByIds = '/videoAi/aiGenerate/historyByIds';
  static const String _getShopList = '/videoAi/shop/getShopList';
  static const String _createOrder = '/videoAi/shop/createOrder';
  static const String _createAppleOrder = '/videoAi/apple/newOrder';
  static const String _verifyOrder = '/videoAi/shop/verifyOrder';
  static const String _verifyAppleOrder = '/videoAi/apple/verifyOrder';
  static const String _getOrderKey = '/videoAi/shop/getOrderKey';
  static const String _userEdit = '/videoAi/user/edit';
  static const String _getEffectTags = '/videoAi/configure/getEffectTags';
  static const String _commonConfigList =
      '/videoAi/configure/getCommonConfigList';
  static const String _feedback = '/videoAi/feedback';

  static Future<ConfigModel> getCommonConfig() async {
    final res = await DioUtil.httpPost(_commonConfigList, data: {
      "configList": [
        {"configName": "limited_offer_popup", "configType": 0},
        {"configName": "creation_layout_switch", "configType": 0},
        {"configName": "jump_config", "configType": 0},
      ]
    });
    try {
      return ConfigModel.fromJson(res);
    } catch (e) {
      Get.snackbar('Model.fromJson error', e.toString());
      rethrow;
    }
  }

  static Future<dynamic> getUploadToken() async {
    return await DioUtil.httpGet(_uploadToken);
  }

  static Future<dynamic> getPointRecordList(
      {required int pageNum, int pageSize = 10}) async {
    return await DioUtil.httpGet(_pointRecordList,
        allData: true, parameters: {"pageNum": pageNum, 'pageSize': pageSize});
  }

  /// loginType 5 apple  2 google
  static Future<dynamic> oneClickLogin(
      String uid, String email, int loginType) async {
    return await DioUtil.httpPost(_oneClickLogin,
        data: {'uniqueId': uid, 'email': email, 'loginType': loginType});
  }

  static Future<dynamic> aiGenerate(String prompt, String? inputImageUrl,
      int? effectId, String? ratio, int? resolution, int? duration, int? num) async {
    return await DioUtil.httpPost(_aiGenerate, data: {
      'prompt': prompt,
      'inputImageUrl': inputImageUrl,
      "effectId": effectId,
      "ratio": ratio,
      "resolution": resolution,
      "duration": duration,
      "number": num
    });
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
      Get.log("Model.fromJson error ${e.toString()}");
      return [];
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

  static Future<void> feedback(int issueType) async {
    return await DioUtil.httpPost(_feedback,
        data: {'type': 3, 'issueType': issueType});
  }

  static Future<dynamic> getRecords(int pageNum) async {
    return await DioUtil.httpGet(_getRecords,
        allData: true, parameters: {'pageNum': pageNum, 'pageSize': 20});
  }

  static Future<dynamic> getRecommendPrompt() async {
    return await DioUtil.httpGet(_recommendPrompt);
  }

  /// 查询商品列表
  ///
  /// [type]: 0 会员商品
  static Future<List<dynamic>> getShopList(int type) async {
    return await DioUtil.httpGet(_getShopList, parameters: {"type": type});
  }

  /// 创建订单
  static Future<dynamic> createOrder(String shopId) async {
    return await DioUtil.httpPost(
        GetPlatform.isAndroid ? _createOrder : _createAppleOrder,
        data: {"shopId": shopId});
  }

  /// 验证订单
  static Future<dynamic> verifyOrder(String data, int timeStamp) async {
    return await DioUtil.httpPost(
        GetPlatform.isAndroid ? _verifyOrder : _verifyAppleOrder,
        data: {"data": data, "timeStamp": timeStamp},
        ignore208: true);
  }

  static Future<dynamic> getOrderKey() async {
    return await DioUtil.httpGet(_getOrderKey);
  }

  static Future<List<dynamic>> getEffectsTags() async {
    return await DioUtil.httpGet(_getEffectTags);
  }

  static Future<void> userEdit(String nickname) async {
    return await DioUtil.httpPost(_userEdit, data: {'nickname': nickname});
  }
}
