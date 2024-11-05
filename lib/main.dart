import 'package:advertising_id/advertising_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/startup_bindings.dart';
import 'package:video_ai/languages/Languages.dart';
import 'package:video_ai/pages/main_page.dart';
import 'package:video_ai/widgets/easy_refresh_custom.dart';

import 'api/dio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarDividerColor: Colors.transparent));
  }
  await initMain();
  runApp(const MainApp());
}

Future<void> initMain() async {
  EasyRefreshCustom.setup();
  var packageInfo = await PackageInfo.fromPlatform();
  GlobalData.packageName = packageInfo.packageName;
  GlobalData.versionName = packageInfo.version;
  SharedPreferences.setPrefix("video_lab");
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  if (token != null) {
    DioUtil.token = token;
  }
  DioUtil.resetDio();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: 'VideoLab',
      translations: Languages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      initialBinding: StartupBindings(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, elevation: 0),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black, primary: UiColors.primary),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
