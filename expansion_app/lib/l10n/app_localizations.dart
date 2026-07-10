import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// Название приложения в списке задач ОС
  ///
  /// In ru, this message translates to:
  /// **'Expansion'**
  String get appTitle;

  /// Первая строка заголовка на splash
  ///
  /// In ru, this message translates to:
  /// **'КОСМИЧЕСКАЯ'**
  String get splashTitleSpace;

  /// Вторая строка заголовка на splash
  ///
  /// In ru, this message translates to:
  /// **'ЭКСПАНСИЯ'**
  String get splashTitleExpansion;

  /// No description provided for @splashPretext.
  ///
  /// In ru, this message translates to:
  /// **'2222 год. Перенаселение Земли, голод и нехватка ресурсов вынудили человечество осваивать планеты Солнечной системы. Тем временем со спутников сообщили: Плутон захвачен пришельцами. Наша экспансия столкнулась с чужой. Руководить этим непростым делом решили доверить вам — бывшему военному. Судьба человечества в ваших руках!'**
  String get splashPretext;

  /// No description provided for @splashLoadLabel.
  ///
  /// In ru, this message translates to:
  /// **'загрузка...'**
  String get splashLoadLabel;

  /// No description provided for @splashBeginGame.
  ///
  /// In ru, this message translates to:
  /// **'Начать новую игру'**
  String get splashBeginGame;

  /// No description provided for @splashMenuProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get splashMenuProfile;

  /// No description provided for @splashMenuSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get splashMenuSettings;

  /// No description provided for @splashMenuProgress.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс'**
  String get splashMenuProgress;

  /// No description provided for @splashMenuNewGame.
  ///
  /// In ru, this message translates to:
  /// **'Новая игра'**
  String get splashMenuNewGame;

  /// No description provided for @splashMenuUpgrades.
  ///
  /// In ru, this message translates to:
  /// **'Улучшения'**
  String get splashMenuUpgrades;

  /// No description provided for @splashMenuContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get splashMenuContinue;

  /// No description provided for @splashFeatureSoon.
  ///
  /// In ru, this message translates to:
  /// **'Раздел в разработке — скоро будет доступен.'**
  String get splashFeatureSoon;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In ru, this message translates to:
  /// **'Общие'**
  String get settingsSectionGeneral;

  /// No description provided for @settingsReplayIntro.
  ///
  /// In ru, this message translates to:
  /// **'Показать вступление снова'**
  String get settingsReplayIntro;

  /// No description provided for @settingsReplayIntroHint.
  ///
  /// In ru, this message translates to:
  /// **'Открыть экран с полной историей'**
  String get settingsReplayIntroHint;

  /// No description provided for @settingsLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык интерфейса'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageHint.
  ///
  /// In ru, this message translates to:
  /// **'Применяется ко всем экранам'**
  String get settingsLanguageHint;

  /// No description provided for @settingsLanguageRu.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get settingsLanguageRu;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @splashDontShowAgain.
  ///
  /// In ru, this message translates to:
  /// **'Не показывать при следующей загрузке'**
  String get splashDontShowAgain;

  /// No description provided for @introStoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'История'**
  String get introStoryTitle;

  /// No description provided for @mapsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Карта кампании'**
  String get mapsTitle;

  /// No description provided for @beginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая игра'**
  String get beginTitle;

  /// No description provided for @battleTitle.
  ///
  /// In ru, this message translates to:
  /// **'Бой'**
  String get battleTitle;

  /// No description provided for @profileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTitle;

  /// No description provided for @progressTitle.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс'**
  String get progressTitle;

  /// No description provided for @upgradesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Улучшения'**
  String get upgradesTitle;

  /// No description provided for @screenPlaceholderBody.
  ///
  /// In ru, this message translates to:
  /// **'Раздел в разработке. Контент и логика — на следующих этапах.'**
  String get screenPlaceholderBody;

  /// No description provided for @bootstrapInitFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось подготовить локальную базу. Повторите запуск приложения.'**
  String get bootstrapInitFailed;

  /// No description provided for @mapsStartBattle.
  ///
  /// In ru, this message translates to:
  /// **'Экспансия'**
  String get mapsStartBattle;

  /// No description provided for @mapsDescriptionFallback.
  ///
  /// In ru, this message translates to:
  /// **'Разведка системы продолжается. Готовьтесь к бою.'**
  String get mapsDescriptionFallback;

  /// No description provided for @mapsLoadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить карту кампании.'**
  String get mapsLoadFailed;

  /// No description provided for @mapsMissionCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Пройдено'**
  String get mapsMissionCompleted;

  /// No description provided for @mapsUnknownSystem.
  ///
  /// In ru, this message translates to:
  /// **'???????'**
  String get mapsUnknownSystem;

  /// No description provided for @beginDifficultyHint.
  ///
  /// In ru, this message translates to:
  /// **'Выберите сложность. От неё зависит темп и непредсказуемость чужих.'**
  String get beginDifficultyHint;

  /// No description provided for @beginDifficultyEasy.
  ///
  /// In ru, this message translates to:
  /// **'Лёгкая'**
  String get beginDifficultyEasy;

  /// No description provided for @beginDifficultyAverage.
  ///
  /// In ru, this message translates to:
  /// **'Средняя'**
  String get beginDifficultyAverage;

  /// No description provided for @beginDifficultyHard.
  ///
  /// In ru, this message translates to:
  /// **'Сложная'**
  String get beginDifficultyHard;

  /// No description provided for @beginStartMission.
  ///
  /// In ru, this message translates to:
  /// **'Спасти человечество'**
  String get beginStartMission;

  /// No description provided for @beginUniverHint.
  ///
  /// In ru, this message translates to:
  /// **'Вселенная (режим кампании)'**
  String get beginUniverHint;

  /// No description provided for @beginUniverClassic.
  ///
  /// In ru, this message translates to:
  /// **'Классическая'**
  String get beginUniverClassic;

  /// No description provided for @beginUniverClassicHint.
  ///
  /// In ru, this message translates to:
  /// **'40 миссий кампании'**
  String get beginUniverClassicHint;

  /// No description provided for @beginUniverGenerated.
  ///
  /// In ru, this message translates to:
  /// **'Случайная'**
  String get beginUniverGenerated;

  /// No description provided for @beginUniverStrategic.
  ///
  /// In ru, this message translates to:
  /// **'Стратегическая'**
  String get beginUniverStrategic;

  /// No description provided for @beginUniverComingSoon.
  ///
  /// In ru, this message translates to:
  /// **'Скоро'**
  String get beginUniverComingSoon;

  /// No description provided for @beginResetConfirmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Начать заново?'**
  String get beginResetConfirmTitle;

  /// No description provided for @beginResetConfirmBody.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс кампании, очки и улучшения будут сброшены. Это нельзя отменить.'**
  String get beginResetConfirmBody;

  /// No description provided for @beginResetConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить и начать'**
  String get beginResetConfirm;

  /// No description provided for @beginResetCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get beginResetCancel;

  /// No description provided for @progressDifficulty.
  ///
  /// In ru, this message translates to:
  /// **'Сложность'**
  String get progressDifficulty;

  /// No description provided for @progressUniver.
  ///
  /// In ru, this message translates to:
  /// **'Вселенная'**
  String get progressUniver;

  /// No description provided for @battleBriefingFallback.
  ///
  /// In ru, this message translates to:
  /// **'Захватите все вражеские базы.'**
  String get battleBriefingFallback;

  /// No description provided for @battleDragHint.
  ///
  /// In ru, this message translates to:
  /// **'Проведите палец от своей базы к цели. Тап по своей базе — улучшения.'**
  String get battleDragHint;

  /// No description provided for @battleBaseSummary.
  ///
  /// In ru, this message translates to:
  /// **'Корабли {ships} · Щит {shield} · Ресурсы {resources}'**
  String battleBaseSummary(int ships, int shield, int resources);

  /// No description provided for @tacticalUpgradeShieldShort.
  ///
  /// In ru, this message translates to:
  /// **'Щит'**
  String get tacticalUpgradeShieldShort;

  /// No description provided for @tacticalUpgradeBuildShort.
  ///
  /// In ru, this message translates to:
  /// **'Постр.'**
  String get tacticalUpgradeBuildShort;

  /// No description provided for @tacticalUpgradeMaxShipsShort.
  ///
  /// In ru, this message translates to:
  /// **'Лимит'**
  String get tacticalUpgradeMaxShipsShort;

  /// No description provided for @battleMeteoriteTutorialTitle.
  ///
  /// In ru, this message translates to:
  /// **'Метеорит!'**
  String get battleMeteoriteTutorialTitle;

  /// No description provided for @battleMeteoriteTutorialBody.
  ///
  /// In ru, this message translates to:
  /// **'Астероид пролетает через поле. При столкновении с базой сначала снимает щит, затем уничтожает корабли. Держите щит или уводите флот с траектории.'**
  String get battleMeteoriteTutorialBody;

  /// No description provided for @battleMeteoriteTutorialDismiss.
  ///
  /// In ru, this message translates to:
  /// **'Понятно'**
  String get battleMeteoriteTutorialDismiss;

  /// No description provided for @battleTacticalSwipeHint.
  ///
  /// In ru, this message translates to:
  /// **'Смахните вниз или нажмите ✕'**
  String get battleTacticalSwipeHint;

  /// No description provided for @battleTacticalClose.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get battleTacticalClose;

  /// No description provided for @battleSendFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось отправить флот: выберите свою базу, дождитесь конца полёта или проверьте линию.'**
  String get battleSendFailed;

  /// No description provided for @battleTacticalTitle.
  ///
  /// In ru, this message translates to:
  /// **'Улучшения базы'**
  String get battleTacticalTitle;

  /// No description provided for @battleTacticalResources.
  ///
  /// In ru, this message translates to:
  /// **'Ресурсы: {amount}'**
  String battleTacticalResources(int amount);

  /// No description provided for @tacticalUpgradeShield.
  ///
  /// In ru, this message translates to:
  /// **'Усилить щит (+20)'**
  String get tacticalUpgradeShield;

  /// No description provided for @tacticalUpgradeBuild.
  ///
  /// In ru, this message translates to:
  /// **'Ускорить постройку'**
  String get tacticalUpgradeBuild;

  /// No description provided for @tacticalUpgradeMaxShips.
  ///
  /// In ru, this message translates to:
  /// **'Расширить лимит кораблей'**
  String get tacticalUpgradeMaxShips;

  /// No description provided for @battleTacticalBuy.
  ///
  /// In ru, this message translates to:
  /// **'{cost}'**
  String battleTacticalBuy(int cost);

  /// No description provided for @battleTacticalMaxLabel.
  ///
  /// In ru, this message translates to:
  /// **'Макс.'**
  String get battleTacticalMaxLabel;

  /// No description provided for @battleTacticalSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Улучшение применено'**
  String get battleTacticalSuccess;

  /// No description provided for @battleTacticalNotEnough.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно ресурсов на базе'**
  String get battleTacticalNotEnough;

  /// No description provided for @battleTacticalMax.
  ///
  /// In ru, this message translates to:
  /// **'Достигнут максимум улучшений'**
  String get battleTacticalMax;

  /// No description provided for @battleTacticalBusy.
  ///
  /// In ru, this message translates to:
  /// **'Дождитесь завершения полёта флота или астероида'**
  String get battleTacticalBusy;

  /// No description provided for @battleVictoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Победа'**
  String get battleVictoryTitle;

  /// No description provided for @battleVictoryBody.
  ///
  /// In ru, this message translates to:
  /// **'Система под контролем. Следующая миссия открыта на карте.'**
  String get battleVictoryBody;

  /// No description provided for @battleVictoryBodyWithScore.
  ///
  /// In ru, this message translates to:
  /// **'Система под контролем. Награда: {score} очков. Следующая миссия на карте.'**
  String battleVictoryBodyWithScore(int score);

  /// No description provided for @metaUpgradeScore.
  ///
  /// In ru, this message translates to:
  /// **'Очки: {score}'**
  String metaUpgradeScore(int score);

  /// No description provided for @metaUpgradeShipSpeed.
  ///
  /// In ru, this message translates to:
  /// **'Скорость флота'**
  String get metaUpgradeShipSpeed;

  /// No description provided for @metaUpgradeShipDurability.
  ///
  /// In ru, this message translates to:
  /// **'Сила атаки'**
  String get metaUpgradeShipDurability;

  /// No description provided for @metaUpgradeShipBuildSpeed.
  ///
  /// In ru, this message translates to:
  /// **'Постройка кораблей'**
  String get metaUpgradeShipBuildSpeed;

  /// No description provided for @metaUpgradeResourceIncome.
  ///
  /// In ru, this message translates to:
  /// **'Доход ресурсов'**
  String get metaUpgradeResourceIncome;

  /// No description provided for @metaUpgradeShield.
  ///
  /// In ru, this message translates to:
  /// **'Прочность щита'**
  String get metaUpgradeShield;

  /// No description provided for @metaUpgradeBeginShips.
  ///
  /// In ru, this message translates to:
  /// **'Стартовые корабли'**
  String get metaUpgradeBeginShips;

  /// No description provided for @metaUpgradeLevel.
  ///
  /// In ru, this message translates to:
  /// **'Ур. {level} (+{percent}%)'**
  String metaUpgradeLevel(int level, int percent);

  /// No description provided for @metaUpgradeBuy.
  ///
  /// In ru, this message translates to:
  /// **'{cost}'**
  String metaUpgradeBuy(int cost);

  /// No description provided for @metaUpgradeMax.
  ///
  /// In ru, this message translates to:
  /// **'Макс.'**
  String get metaUpgradeMax;

  /// No description provided for @metaUpgradePurchased.
  ///
  /// In ru, this message translates to:
  /// **'Улучшение куплено'**
  String get metaUpgradePurchased;

  /// No description provided for @metaUpgradeNotEnough.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно очков'**
  String get metaUpgradeNotEnough;

  /// No description provided for @progressCurrentMission.
  ///
  /// In ru, this message translates to:
  /// **'Текущая миссия'**
  String get progressCurrentMission;

  /// No description provided for @progressCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Пройдено миссий'**
  String get progressCompleted;

  /// No description provided for @progressScore.
  ///
  /// In ru, this message translates to:
  /// **'Очки'**
  String get progressScore;

  /// No description provided for @progressEnemyPower.
  ///
  /// In ru, this message translates to:
  /// **'Сила чужих (кампания)'**
  String get progressEnemyPower;

  /// No description provided for @battleDefeatTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поражение'**
  String get battleDefeatTitle;

  /// No description provided for @battleDefeatBody.
  ///
  /// In ru, this message translates to:
  /// **'Флот разбит. Попробуйте снова или снизьте сложность.'**
  String get battleDefeatBody;

  /// No description provided for @battleContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get battleContinue;

  /// No description provided for @battleScenePlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Миссия {sceneId}. Бой — в разработке (фаза 3).'**
  String battleScenePlaceholder(int sceneId);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
