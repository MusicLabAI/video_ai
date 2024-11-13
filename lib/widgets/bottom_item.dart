import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_ai/common/common_util.dart';

import '../../common/global_data.dart';
import '../common/ui_colors.dart';

class BottomItem extends StatelessWidget {
  BottomItem({super.key, this.text, this.onTap});

  String? text;
  VoidCallback? onTap;

  final TextStyle _bottomTextStyle = const TextStyle(
    fontSize: 12,
    color: UiColors.c61FFFFFF,
    fontWeight: FontWeightExt.bold,
    decoration: TextDecoration.underline,
    decorationColor: UiColors.c61FFFFFF,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (text != null)
          GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  text!,
                  style: _bottomTextStyle,
                ),
              )),
        if (text != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '|',
              style: _bottomTextStyle,
            ),
          ),
        GestureDetector(
            onTap: () async {
              CommonUtil.openUrl(GlobalData.termsOfUseUrl);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                GetPlatform.isAndroid ? 'termsOfUse'.tr : 'eula'.tr,
                style: _bottomTextStyle,
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '|',
            style: _bottomTextStyle,
          ),
        ),
        GestureDetector(
          onTap: () async {
            CommonUtil.openUrl(GlobalData.privacyNoticeUrl);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'privacyNotice'.tr,
              style: _bottomTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
