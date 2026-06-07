import 'package:evex_user/app/helpers/cache_helper.dart';
import 'package:evex_user/core/constants/cash_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final CacheHelper _cacheHelper;

  LanguageCubit(this._cacheHelper)
      : super(LanguageState(_loadLocale(_cacheHelper)));

  static Locale _loadLocale(CacheHelper cache) {
    final code = cache.getData(CacheKeys.languageCode) as String? ?? 'ar';
    return Locale(code);
  }

  void changeLanguage(String languageCode) {
    _cacheHelper.saveData(key: CacheKeys.languageCode, value: languageCode);
    emit(LanguageState(Locale(languageCode)));
  }

  void toggleLanguage() {
    final next = state.locale.languageCode == 'ar' ? 'en' : 'ar';
    changeLanguage(next);
  }
}
