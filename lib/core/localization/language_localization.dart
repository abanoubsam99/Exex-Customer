import 'package:evex_user/core/localization/arabic_language.dart';
import 'package:evex_user/core/localization/english_language.dart';
import 'package:get/get.dart';

//Class that's responsible for Translation ->Localization part
class LanguageLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': arabicLanguage,
        'en': englishLanguage,
      };
}
