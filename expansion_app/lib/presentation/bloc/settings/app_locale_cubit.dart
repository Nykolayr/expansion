import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/l10n/app_locale_policy.dart';

/// Выбранный язык приложения (ru / en).
class AppLocaleCubit extends Cubit<Locale> {
  AppLocaleCubit(this._prefs)
      : super(AppLocalePolicy.resolveDefault(PlatformDispatcher.instance.locale));

  final SharedPreferences _prefs;

  Future<void> load() async {
    final code = _prefs.getString(PrefsKeys.appLocale);
    if (code != null && code.isNotEmpty) {
      emit(Locale(code));
      return;
    }

    final locale =
        AppLocalePolicy.resolveDefault(PlatformDispatcher.instance.locale);
    await _prefs.setString(PrefsKeys.appLocale, locale.languageCode);
    emit(locale);
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(PrefsKeys.appLocale, locale.languageCode);
    emit(locale);
  }
}
