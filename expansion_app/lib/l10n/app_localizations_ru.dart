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
  String get settingsLanguage => 'Язык интерфейса';

  @override
  String get settingsLanguageHint => 'Применяется ко всем экранам';

  @override
  String get settingsLanguageRu => 'Русский';

  @override
  String get settingsLanguageEn => 'English';

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
  String get upgradesTitle => 'Улучшения';

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
  String get mapsMissionCompleted => 'Пройдено';

  @override
  String get mapsUnknownSystem => '???????';

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
  String get beginUniverHint => 'Вселенная (режим кампании)';

  @override
  String get beginUniverClassic => 'Классическая';

  @override
  String get beginUniverClassicHint => '40 миссий кампании';

  @override
  String get beginUniverGenerated => 'Случайная';

  @override
  String get beginUniverStrategic => 'Стратегическая';

  @override
  String get beginUniverComingSoon => 'Скоро';

  @override
  String get beginResetConfirmTitle => 'Начать заново?';

  @override
  String get beginResetConfirmBody =>
      'Прогресс кампании, очки и улучшения будут сброшены. Это нельзя отменить.';

  @override
  String get beginResetConfirm => 'Сбросить и начать';

  @override
  String get beginResetCancel => 'Отмена';

  @override
  String get progressDifficulty => 'Сложность';

  @override
  String get progressUniver => 'Вселенная';

  @override
  String get battleBriefingFallback => 'Захватите все вражеские базы.';

  @override
  String get battleDragHint =>
      'Проведите палец от своей базы к цели. Тап по своей базе — улучшения.';

  @override
  String get battleTacticalSwipeHint => 'Смахните вниз или нажмите ✕';

  @override
  String get battleTacticalClose => 'Закрыть';

  @override
  String get battleSendFailed =>
      'Не удалось отправить флот: выберите свою базу, дождитесь конца полёта или проверьте линию.';

  @override
  String get battleTacticalTitle => 'Улучшения базы';

  @override
  String battleTacticalResources(int amount) {
    return 'Ресурсы: $amount';
  }

  @override
  String get tacticalUpgradeShield => 'Усилить щит (+20)';

  @override
  String get tacticalUpgradeBuild => 'Ускорить постройку';

  @override
  String get tacticalUpgradeMaxShips => 'Расширить лимит кораблей';

  @override
  String battleTacticalBuy(int cost) {
    return '$cost';
  }

  @override
  String get battleTacticalMaxLabel => 'Макс.';

  @override
  String get battleTacticalSuccess => 'Улучшение применено';

  @override
  String get battleTacticalNotEnough => 'Недостаточно ресурсов на базе';

  @override
  String get battleTacticalMax => 'Достигнут максимум улучшений';

  @override
  String get battleTacticalBusy =>
      'Дождитесь завершения полёта флота или астероида';

  @override
  String get battleVictoryTitle => 'Победа';

  @override
  String get battleVictoryBody =>
      'Система под контролем. Следующая миссия открыта на карте.';

  @override
  String battleVictoryBodyWithScore(int score) {
    return 'Система под контролем. Награда: $score очков. Следующая миссия на карте.';
  }

  @override
  String metaUpgradeScore(int score) {
    return 'Очки: $score';
  }

  @override
  String get metaUpgradeShipSpeed => 'Скорость флота';

  @override
  String get metaUpgradeShipDurability => 'Сила атаки';

  @override
  String get metaUpgradeShipBuildSpeed => 'Постройка кораблей';

  @override
  String get metaUpgradeResourceIncome => 'Доход ресурсов';

  @override
  String get metaUpgradeShield => 'Прочность щита';

  @override
  String get metaUpgradeBeginShips => 'Стартовые корабли';

  @override
  String metaUpgradeLevel(int level, int percent) {
    return 'Ур. $level (+$percent%)';
  }

  @override
  String metaUpgradeBuy(int cost) {
    return '$cost';
  }

  @override
  String get metaUpgradeMax => 'Макс.';

  @override
  String get metaUpgradePurchased => 'Улучшение куплено';

  @override
  String get metaUpgradeNotEnough => 'Недостаточно очков';

  @override
  String get progressCurrentMission => 'Текущая миссия';

  @override
  String get progressCompleted => 'Пройдено миссий';

  @override
  String get progressScore => 'Очки';

  @override
  String get progressEnemyPower => 'Сила чужих (кампания)';

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
