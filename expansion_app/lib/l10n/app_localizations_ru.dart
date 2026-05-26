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

  @override
  String get mapsTitle => 'Карта кампании';

  @override
  String get beginTitle => 'Новая игра';

  @override
  String get battleTitle => 'Бой';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get progressTitle => 'Прогресс';

  @override
  String get screenPlaceholderBody =>
      'Раздел в разработке. Контент и логика — на следующих этапах.';

  @override
  String get bootstrapInitFailed =>
      'Не удалось подготовить локальную базу. Повторите запуск приложения.';

  @override
  String get mapsStartBattle => 'Экспансия';

  @override
  String get mapsDescriptionFallback =>
      'Разведка системы продолжается. Готовьтесь к бою.';

  @override
  String get mapsLoadFailed => 'Не удалось загрузить карту кампании.';

  @override
  String get beginDifficultyHint =>
      'Выберите сложность. От неё зависит темп и непредсказуемость чужих.';

  @override
  String get beginDifficultyEasy => 'Лёгкая';

  @override
  String get beginDifficultyAverage => 'Средняя';

  @override
  String get beginDifficultyHard => 'Сложная';

  @override
  String get beginStartMission => 'Спасти человечество';

  @override
  String get battleBriefingFallback => 'Захватите все вражеские базы.';

  @override
  String get battleTapHint =>
      'Тап: своя база → цель. Нужна прямая линия без препятствий.';

  @override
  String get battleVictoryTitle => 'Победа';

  @override
  String get battleVictoryBody =>
      'Система под контролем. Следующая миссия открыта на карте.';

  @override
  String get battleDefeatTitle => 'Поражение';

  @override
  String get battleDefeatBody =>
      'Флот разбит. Попробуйте снова или снизьте сложность.';

  @override
  String get battleContinue => 'Продолжить';

  @override
  String battleScenePlaceholder(int sceneId) {
    return 'Миссия $sceneId. Бой — в разработке (фаза 3).';
  }
}
