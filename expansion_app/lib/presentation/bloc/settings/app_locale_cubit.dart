import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';

/// Выбранный язык приложения (ru / en).
class AppLocaleCubit extends Cubit<Locale> {
  AppLocaleCubit(this._prefs) : super(const Locale('ru'));

  final SharedPreferences _prefs;

  Future<void> load() async {
    final code = _prefs.getString(PrefsKeys.appLocale);
    if (code == null || code.isEmpty) return;
    emit(Locale(code));
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(PrefsKeys.appLocale, locale.languageCode);
    emit(locale);
  }
}
