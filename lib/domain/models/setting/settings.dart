import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'settings.freezed.dart';
part 'settings.g.dart';

@Freezed()
class Settings with _$Settings {
  const Settings._();
  const factory Settings({
    @Default(true) bool isMusic,
    @Default(true) bool isSound,
    @Default(Lang.ru) Lang lang,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}

enum Lang {
  ru,
  en;

  Locale get locale {
    switch (this) {
      case Lang.ru:
        return const Locale('ru', 'RU');
      case Lang.en:
        return const Locale('en', 'US');
    }
  }

  String get nameMenu {
    switch (this) {
      case Lang.ru:
        return tr('russian');
      case Lang.en:
        return tr('english');
    }
  }

  String get nameSelectEng {
    switch (this) {
      case Lang.ru:
        return tr('english_$name');
      case Lang.en:
        return tr('english');
    }
  }

  String get nameSelectRu {
    switch (this) {
      case Lang.ru:
        return tr('russian');
      case Lang.en:
        return tr('russian_$name');
    }
  }
}
