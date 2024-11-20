import 'dart:io';
import 'dart:ui';

class UiColors {
  /// 用于禁用遮罩
  static const Color transparentWhite20 = Color(0x33FFFFFF);
  static const Color transparent = Color(0x00FFFFFF);
  static const Color transparent40 = Color(0x66FFFFFF);
  static const Color transparent60 = Color(0x99FFFFFF);
  static const Color transparentPrimary40 = Color(0x66AEE9CD);
  static const Color transparentPrimary70 = Color(0xB240BD95);
  static const Color transparentPrimary20 = Color(0x33AEE9CD);
  static const Color transparentBlack70 = Color(0xB2000000);

  /// 默认
  static const Color primary = cA754FC;

  static const Color black = Color(0xFF000000);

  static const Color white = Color(0xFFFFFFFF);

  static const Color c171C26 = Color(0xFF171C26);

  static const Color c131313 = Color(0xFF131313);

  static const Color c2F3A4D = Color(0xFF2F3A4D);

  static const Color c4D6C83FF = Color(0x4D6C83FF);

  static const Color c42BE8FF7 = Color(0x42BE8FF7);

  static const Color c4D9CA6FF = Color(0x4D9CA6FF);

  static const Color cFC5454 = Color(0xFFFC5454);

  static const Color cA754FC = Color(0xFFA754FC);

  static const Color c7631EC = Color(0xFF7631EC);

  static const Color cA359EF = Color(0xFFA359EF);

  static const Color c6A696F = Color(0xFF6A696F);

  static const Color cBC8EF5 = Color(0xFFBC8EF5);

  static const Color cB8000000 = Color(0xB8000000);

  static const Color c2B2E38 = Color(0xFF2B2E38);

  static const Color cDBFFFFFF = Color(0xDBFFFFFF);

  static const Color cDEDEDE = Color(0xFFDEDEDE);

  static const Color c4A3663 = Color(0xFF4A3663);

  static const Color cE18FF8 = Color(0xFFE18FF8);

  static const Color c383142 = Color(0xFF383142);

  static const Color cD0D0D0 = Color(0xFFD0D0D0);

  static const Color c23242A = Color(0xFF23242A);

  static const Color c231831 = Color(0xFF231831);

  static const Color c433258 = Color(0xFF433258);

  static const Color c66BE8FF7 = Color(0x66BE8FF7);

  static const Color c99AF6FFF = Color(0x99AF6FFF);

  static const Color c9771C4 = Color(0xFF9771C4);

  static const Color c666949A1 = Color(0x666949A1);

  static const Color c1B1B1F = Color(0xFF1B1B1F);

  static const Color c30333F = Color(0xFF30333F);

  static const Color c61FFFFFF = Color(0x61FFFFFF);

  static const Color c33ADD1FF = Color(0x33ADD1FF);

  static const Color c33FFFFFF = Color(0x33FFFFFF);

  static const Color c99000000 = Color(0x99000000);

  static const Color c66000000 = Color(0x66000000);

  static const Color c9CC2FF = Color(0xFF9CC2FF);

  static const Color c3C3950 = Color(0xFF3C3950);

  static const Color cB3B3B3 = Color(0xFFB3B3B3);

  static const Color c99FFFFFF = Color(0x99FFFFFF);

  static const Color c1AAACFFF = Color(0x1AAACFFF);

  static const Color cFF30333F = Color(0xFF30333F);

  static const Color c1A9CC2FF = Color(0x1A9CC2FF);

  static const Color c121212 = Color(0xFF121212);

  static const Color c626475 = Color(0xFF626475);

  static const Color c262434 = Color(0xFF262434);

  static const Color c848484 = Color(0xFF848484);

  static const Color c272931 = Color(0xFF272931);

  static const Color c282F3C = Color(0xFF282F3C);

  static const Color cF9F9F9 = Color(0xFFF9F9F9);

  static Color hexToColor(String s) {
    if (s.length != 7 || int.tryParse(s.substring(1, 7), radix: 16) == null) {
      return primary;
    }

    return Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

extension FontWeightExt on FontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static FontWeight medium =
      Platform.isAndroid ? FontWeight.w600 : FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}
