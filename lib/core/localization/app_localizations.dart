import 'arabic_language.dart';
import 'english_language.dart';

class AppLocalizations {
  static String _locale = 'ar';

  static void setLocale(String locale) => _locale = locale;
  static String get currentLocale => _locale;

  static String translate(String key) {
    final map = _locale == 'ar' ? arabicLanguage : englishLanguage;
    return map[key] ?? key;
  }
}

extension StringLocalization on String {
  String get tr => AppLocalizations.translate(this);
}
