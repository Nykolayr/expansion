// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Expansion';

  @override
  String get splashTitleSpace => 'КОСМИЧЕСКАЯ';

  @override
  String get splashTitleExpansion => 'ЭКСПАНСИЯ';

  @override
  String get splashPretext =>
      '2222 год. Перенаселение Земли, голод и нехватка ресурсов вынудили человечество осваивать планеты Солнечной системы. Тем временем со спутников сообщили: Плутон захвачен пришельцами. Наша экспансия столкнулась с чужой. Руководить этим непростым делом решили доверить вам — бывшему военному. Судьба человечества в ваших руках!';

  @override
  String get splashLoadLabel => 'загрузка...';

  @override
  String get splashBeginGame => 'Начать новую игру';

  @override
  String get splashMenuProfile => 'Профиль';

  @override
  String get splashMenuSettings => 'Настройки';

  @override
  String get splashMenuProgress => 'Прогресс';

  @override
  String get splashMenuNewGame => 'Новая игра';

  @override
  String get splashMenuUpgrades => 'Улучшения';

  @override
  String get splashMenuContinue => 'Продолжить';

  @override
  String get splashFeatureSoon => 'Раздел в разработке — скоро будет доступен.';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionGeneral => 'Общие';

  @override
  String get settingsReplayIntro => 'Показать вступление снова';

  @override
  String get settingsReplayIntroHint => 'Открыть экран с полной историей';

  @override
  String get splashDontShowAgain => 'Не показывать при следующей загрузке';

  @override
  String get introStoryTitle => 'История';
}
