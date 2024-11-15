import 'package:get/get.dart';
import 'package:video_ai/languages/language_ru.dart';

import 'language_ar.dart';
import 'language_de.dart';
import 'language_en_us.dart';
import 'language_es.dart';
import 'language_fr.dart';
import 'language_it.dart';
import 'language_ja.dart';
import 'language_ko.dart';
import 'language_id.dart';
import 'language_pt.dart';
import 'language_tr.dart';
import 'language_zh_cn.dart';
import 'language_zh_tw.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'zh_CN': LanguageZhCn.language,
      'zh_Hant_HK': LanguageZhTw.language,
      'zh_Hant_TW': LanguageZhTw.language,
      'zh_Hant_MO': LanguageZhTw.language,
      'en_US': LanguageEnUs.language,
      // 阿拉伯语
      'ar': LanguageAr.language,
      // 德语
      'de': LanguageDe.language,
      // 法语
      'fr': LanguageFr.language,
      // 西班牙语
      'es': LanguageEs.language,
      // 意大利语
      'it': LanguageIt.language,
      // 日语
      'ja': LanguageJa.language,
      // 韩语
      'ko': LanguageKo.language,
      // 印尼语
      'id': LanguageId.language,
      // 葡萄牙语
      'pt': LanguagePt.language,
      // 俄语
      'ru': LanguageRu.language,
      // 土耳其
      'tr': LanguageTr.language,
    };
  }
}
