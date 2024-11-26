import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';

import '../common/global_data.dart';
import '../controllers/user_controller.dart';

class DioUtil {
  static String token = '';

  static Dio? _dio;

  static bool resetDio() {
    _dio = null;
    DioUtil._init();
    return true;
  }

  /*
  version-name    //版本号
  Platform   //android或iOS
  region    //地区代码
  adId      //唯一设备ID
  language   //语言代码 
  */
  DioUtil._init() {
    final dl = Get.deviceLocale;
    String language = dl?.languageCode ?? '';
    if (dl?.scriptCode != null && dl!.scriptCode!.isNotEmpty) {
      language += '_${dl.scriptCode}';
    }
    const baseUrl = GlobalData.releaseBaseUrl;
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json,
        listFormat: ListFormat.multiCompatible,
        headers: {
          'token': (GetUtils.isBlank(token) ?? true) ? null : token,
          'platform': GetPlatform.isAndroid ? 'android' : 'ios',
          'version-name': GlobalData.versionName,
          'region': Get.deviceLocale?.countryCode,
          'language': language,
        },
      ),
    );
      // ..interceptors.add(LogInterceptor(responseBody: true));
      // ..interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
  }

  static _exceptionHandling(String? message, Response? response) {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    if (response?.statusCode == 401 || response?.statusCode == 403) {
      SharedPreferences.getInstance().then((value) {
        value.remove('token');
        token = '';
        resetDio();
      });
      UserController().showLogin();
    } else if (response?.statusCode == 500) {
      Get.log(response?.statusMessage ?? response!.statusCode!.toString());
    } else {
      Get.log(response?.statusMessage ??
          response?.statusCode?.toString() ??
          'unknown error');
    }
  }

  static bool _isSuccess(int code) {
    return code == 200 || code == 0;
  }

  static bool _isUnauthorized(int code) {
    return code == 401 || code == 403;
  }

  static Future<void> _handleUnauthorized() async {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token = '';
    resetDio();

    UserController().showLogin();
  }

  static void _handleError(Map<String, dynamic> responseData) {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    if (responseData['code'] == 1577) {
        Fluttertoast.showToast(msg: 'insufficientBalance'.tr);
    }
    String errorMsg = responseData['msg'] ??
        responseData['state'] ??
        responseData['code'].toString();

    Get.log(errorMsg);
  }

  /// get请求
  static dynamic httpGet(String url,
      {Map<String, dynamic>? parameters, bool allData = false}) async {
    try {
      var response = await _dio!.get(url, queryParameters: parameters);
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (_isSuccess(responseData['code'])) {
          return allData ? responseData : responseData['data'];
        } else if (_isUnauthorized(responseData['code'])) {
          await _handleUnauthorized();
        } else {
          _handleError(responseData);
        }
      } else {
        _exceptionHandling(null, response);
      }
      throw response;
    } on DioException catch (e) {
      _exceptionHandling(e.message, e.response);
      rethrow;
    }
  }

  /// delete
  static dynamic httpDelete(String url,
      {Map<String, dynamic>? parameters, bool allData = false}) async {
    try {
      var response = await _dio!.delete(url, queryParameters: parameters);
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (_isSuccess(responseData['code'])) {
          return allData ? responseData : responseData['data'];
        } else if (_isUnauthorized(responseData['code'])) {
          await _handleUnauthorized();
        } else {
          _handleError(responseData);
        }
      } else {
        _exceptionHandling(null, response);
      }
      throw response;
    } on DioException catch (e) {
      _exceptionHandling(e.message, e.response);
      rethrow;
    }
  }

  /// post请求
  static Future<dynamic> httpPost(String url,
      {required Map<String, dynamic> data,
      bool allData = false,
      bool ignore208 = false,
      bool ignoreAll = false}) async {
    try {
      var response = await _dio!.post(url, data: data);
      if (ignoreAll) {
        return response;
      }
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (ignore208 && responseData['code'] == 208) {
          return responseData['data'];
        }
        if (_isSuccess(responseData['code'])) {
          return allData ? responseData : responseData['data'];
        } else if (_isUnauthorized(responseData['code'])) {
          await _handleUnauthorized();
        } else {
          _handleError(responseData);
        }
      } else {
        _exceptionHandling(null, response);
      }
      throw response;
    } on DioException catch (e) {
      _exceptionHandling(e.message, e.response);
    rethrow;
    }
  }
}
