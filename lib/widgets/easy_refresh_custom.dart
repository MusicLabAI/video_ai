import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:video_ai/common/ui_colors.dart';

class EasyRefreshCustom {
  static void setup() {
    // // 全局设置
    EasyRefresh.defaultHeaderBuilder = () => EasyRefreshHeader();
    EasyRefresh.defaultFooterBuilder = () => EasyRefreshFooter();
  }
}

class EasyRefreshHeader extends ClassicHeader {
  EasyRefreshHeader()
      : super(
          showText: false,
          showMessage: false,
          iconTheme: const IconThemeData(color: UiColors.primary),
        );
}

class EasyRefreshFooter extends ClassicFooter {
  EasyRefreshFooter()
      : super(
          showMessage: false,
          showText: false,
          succeededIcon: const SizedBox(),
          noMoreIcon: const SizedBox(),
        );
}
