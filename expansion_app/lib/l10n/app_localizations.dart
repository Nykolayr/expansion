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
  /// **'Показать вступительный текст на стартовом экране'**
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

  /// No description provided for @settingsDifficulty.
  ///
  /// In ru, this message translates to:
  /// **'Сложность кампании'**
  String get settingsDifficulty;

  /// No description provided for @settingsDifficultyHint.
  ///
  /// In ru, this message translates to:
  /// **'Влияет на темп и тактику чужих. Применится со следующего боя.'**
  String get settingsDifficultyHint;

  /// No description provided for @battleDefeatHintStreakBody.
  ///
  /// In ru, this message translates to:
  /// **'Несколько поражений подряд на этой миссии. Попробуйте снизить сложность в настройках — мета-апгрейды сохранятся.'**
  String get battleDefeatHintStreakBody;

  /// No description provided for @battleLowerDifficulty.
  ///
  /// In ru, this message translates to:
  /// **'Снизить сложность'**
  String get battleLowerDifficulty;

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

  /// No description provided for @campaignEpilogueTitle.
  ///
  /// In ru, this message translates to:
  /// **'Победа'**
  String get campaignEpilogueTitle;

  /// No description provided for @campaignEpilogueDismiss.
  ///
  /// In ru, this message translates to:
  /// **'К карте'**
  String get campaignEpilogueDismiss;

  /// No description provided for @campaignEpilogueText.
  ///
  /// In ru, this message translates to:
  /// **'Командир! Благодаря только вашему командованию мы разгромили вторгшихся захватчиков и очистили звёздный сектор от угрозы. Все {missionCount} систем этой кампании — под нашим контролем.\n\nРазведка докладывает: открыты новые маршруты. Впереди десятки звёздных систем, готовых принять колонистов. Человечество снова смотрит в глубину космоса с надеждой — и снова на вас.\n\nОтдышитесь, укрепите базы, готовьте флот. Экспансия продолжается. Это ваша победа.'**
  String campaignEpilogueText(int missionCount);

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

  /// No description provided for @battleLayoutNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Раскладка боя для этой миссии не найдена.'**
  String get battleLayoutNotFound;

  /// No description provided for @guestDefaultName.
  ///
  /// In ru, this message translates to:
  /// **'Гость'**
  String get guestDefaultName;

  /// No description provided for @battlePauseTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пауза'**
  String get battlePauseTitle;

  /// No description provided for @battlePauseContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get battlePauseContinue;

  /// No description provided for @battlePauseRestart.
  ///
  /// In ru, this message translates to:
  /// **'Перезапустить'**
  String get battlePauseRestart;

  /// No description provided for @battlePauseExitMain.
  ///
  /// In ru, this message translates to:
  /// **'Выйти в главное'**
  String get battlePauseExitMain;

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
  /// **'Астероид!'**
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

  /// No description provided for @battleVictoryRewardDetail.
  ///
  /// In ru, this message translates to:
  /// **'База: {base} + миссия: {bonus} = {total} очков.'**
  String battleVictoryRewardDetail(int base, int bonus, int total);

  /// No description provided for @battleVictoryToMap.
  ///
  /// In ru, this message translates to:
  /// **'На карту'**
  String get battleVictoryToMap;

  /// No description provided for @battleVictoryToUpgrades.
  ///
  /// In ru, this message translates to:
  /// **'Улучшения'**
  String get battleVictoryToUpgrades;

  /// No description provided for @battleVictoryNextMission.
  ///
  /// In ru, this message translates to:
  /// **'Следующая миссия ({id})'**
  String battleVictoryNextMission(int id);

  /// No description provided for @battleTutorialDragTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отправка флота'**
  String get battleTutorialDragTitle;

  /// No description provided for @battleTutorialDragBody.
  ///
  /// In ru, this message translates to:
  /// **'Свайп от своей базы (синяя) к соседней цели. Отправится половина кораблей на базе.'**
  String get battleTutorialDragBody;

  /// No description provided for @battleTutorialCaptureTitle.
  ///
  /// In ru, this message translates to:
  /// **'Захват'**
  String get battleTutorialCaptureTitle;

  /// No description provided for @battleTutorialCaptureBody.
  ///
  /// In ru, this message translates to:
  /// **'Смотрите на поле: флот летит к цели (пульс на базе). После захвата тапните захваченную базу.'**
  String get battleTutorialCaptureBody;

  /// No description provided for @battleTutorialUpgradeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Улучшения базы'**
  String get battleTutorialUpgradeTitle;

  /// No description provided for @battleTutorialUpgradeBody.
  ///
  /// In ru, this message translates to:
  /// **'Тапните захваченную базу на поле. Купите улучшение или нажмите «Понятно» — дальше расскажем про врага и цель боя.'**
  String get battleTutorialUpgradeBody;

  /// No description provided for @battleTutorialGoalTitle.
  ///
  /// In ru, this message translates to:
  /// **'Цель боя'**
  String get battleTutorialGoalTitle;

  /// No description provided for @battleTutorialGoalBody.
  ///
  /// In ru, this message translates to:
  /// **'Красные базы врага тоже отправляют флоты и захватывают ваши и нейтральные базы. Победа — когда не останется вражеских баз. Поражение — если потеряете все свои базы.'**
  String get battleTutorialGoalBody;

  /// No description provided for @battleTutorialDismiss.
  ///
  /// In ru, this message translates to:
  /// **'Понятно'**
  String get battleTutorialDismiss;

  /// No description provided for @battleTutorialSkip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get battleTutorialSkip;

  /// No description provided for @battleIntroMediumBaseTitle.
  ///
  /// In ru, this message translates to:
  /// **'Средняя база'**
  String get battleIntroMediumBaseTitle;

  /// No description provided for @battleIntroMediumBaseBody.
  ///
  /// In ru, this message translates to:
  /// **'Старт 40 кораблей, лимит 50. Сложнее захватить, чем малую (20/30).'**
  String get battleIntroMediumBaseBody;

  /// No description provided for @battleIntroLargeBaseTitle.
  ///
  /// In ru, this message translates to:
  /// **'Большая база'**
  String get battleIntroLargeBaseTitle;

  /// No description provided for @battleIntroLargeBaseBody.
  ///
  /// In ru, this message translates to:
  /// **'Старт 60 кораблей, лимит 80. Берите последней — нужен крупный флот.'**
  String get battleIntroLargeBaseBody;

  /// No description provided for @battleIntroRichBaseTitle.
  ///
  /// In ru, this message translates to:
  /// **'Богатая база'**
  String get battleIntroRichBaseTitle;

  /// No description provided for @battleIntroRichBaseBody.
  ///
  /// In ru, this message translates to:
  /// **'Даёт в 5 раз больше ресурсов (×5). Захватывайте для улучшений. Не отправляйте отсюда флот в атаку — держите базу в тылу.'**
  String get battleIntroRichBaseBody;

  /// No description provided for @battleIntroShieldedBaseTitle.
  ///
  /// In ru, this message translates to:
  /// **'База со щитом'**
  String get battleIntroShieldedBaseTitle;

  /// No description provided for @battleIntroShieldedBaseBody.
  ///
  /// In ru, this message translates to:
  /// **'Стартовый щит поглощает урон от астероидов, комет и прочих космических угроз. Сначала бейте по щиту, потом по кораблям.'**
  String get battleIntroShieldedBaseBody;

  /// No description provided for @battleIntroFactoryBaseTitle.
  ///
  /// In ru, this message translates to:
  /// **'Фабрика'**
  String get battleIntroFactoryBaseTitle;

  /// No description provided for @battleIntroFactoryBaseBody.
  ///
  /// In ru, this message translates to:
  /// **'Строит корабли в 5 раз быстрее (×5), но стартовый гарнизон меньше. Захватите и удержите — фабрика быстро разгонится.'**
  String get battleIntroFactoryBaseBody;

  /// No description provided for @battleIntroBunkerBaseTitle.
  ///
  /// In ru, this message translates to:
  /// **'Бункер'**
  String get battleIntroBunkerBaseTitle;

  /// No description provided for @battleIntroBunkerBaseBody.
  ///
  /// In ru, this message translates to:
  /// **'Высокий лимит кораблей и крепкий гарнизон, но медленный рост. Сложнее выбить, нужен крупный флот.'**
  String get battleIntroBunkerBaseBody;

  /// No description provided for @battleIntroCometTitle.
  ///
  /// In ru, this message translates to:
  /// **'Комета!'**
  String get battleIntroCometTitle;

  /// No description provided for @battleIntroCometBody.
  ///
  /// In ru, this message translates to:
  /// **'Комета влетает по дуге от угла поля. Бьёт базы и флоты на пути — следите за неожиданными траекториями.'**
  String get battleIntroCometBody;

  /// No description provided for @battleIntroPulseTitle.
  ///
  /// In ru, this message translates to:
  /// **'Энергоимпульс!'**
  String get battleIntroPulseTitle;

  /// No description provided for @battleIntroPulseBody.
  ///
  /// In ru, this message translates to:
  /// **'Импульс расходится от центра по кресту. Задевает базы и флоты на линиях — планируйте маршруты с запасом.'**
  String get battleIntroPulseBody;

  /// No description provided for @battleIntroDroneTitle.
  ///
  /// In ru, this message translates to:
  /// **'Дроны снабжения'**
  String get battleIntroDroneTitle;

  /// No description provided for @battleIntroDroneBody.
  ///
  /// In ru, this message translates to:
  /// **'Периодически подкидывают корабли на базы врага. Давите вражеские базы быстрее, пока дроны их усиливают.'**
  String get battleIntroDroneBody;

  /// No description provided for @battleDebrisTutorialTitle.
  ///
  /// In ru, this message translates to:
  /// **'Метеоритный поток!'**
  String get battleDebrisTutorialTitle;

  /// No description provided for @battleDebrisTutorialBody.
  ///
  /// In ru, this message translates to:
  /// **'Метеоритный поток летит поперёк по центру поля. Уничтожает 80% кораблей флота и гарнизона на пути и пролетает дальше — не ведите корабли через центр без нужды.'**
  String get battleDebrisTutorialBody;

  /// No description provided for @metaUpgradeLevelShort.
  ///
  /// In ru, this message translates to:
  /// **'Ур. {level}'**
  String metaUpgradeLevelShort(int level);

  /// No description provided for @mapTutorialTitle.
  ///
  /// In ru, this message translates to:
  /// **'Карта кампании'**
  String get mapTutorialTitle;

  /// No description provided for @mapTutorialBody.
  ///
  /// In ru, this message translates to:
  /// **'Выберите систему и нажмите «Экспансия», чтобы начать бой. Пройденные миссии можно переигрывать.'**
  String get mapTutorialBody;

  /// No description provided for @mapTutorialDismiss.
  ///
  /// In ru, this message translates to:
  /// **'Вперёд'**
  String get mapTutorialDismiss;

  /// No description provided for @mapTutorialLater.
  ///
  /// In ru, this message translates to:
  /// **'Позже'**
  String get mapTutorialLater;

  /// No description provided for @helpTitle.
  ///
  /// In ru, this message translates to:
  /// **'Справка'**
  String get helpTitle;

  /// No description provided for @helpBattleTitle.
  ///
  /// In ru, this message translates to:
  /// **'Бой'**
  String get helpBattleTitle;

  /// No description provided for @helpBattleBody.
  ///
  /// In ru, this message translates to:
  /// **'Свайп между базами отправляет флот по прямой, если путь свободен. Захватите все вражеские базы. Астероиды бьют по щиту и кораблям.'**
  String get helpBattleBody;

  /// No description provided for @helpMapTitle.
  ///
  /// In ru, this message translates to:
  /// **'Карта'**
  String get helpMapTitle;

  /// No description provided for @helpMapBody.
  ///
  /// In ru, this message translates to:
  /// **'40 миссий Classic. Текущая отмечена мишенью. После победы открывается следующая система.'**
  String get helpMapBody;

  /// No description provided for @helpUpgradesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Апгрейды'**
  String get helpUpgradesTitle;

  /// No description provided for @helpUpgradesBody.
  ///
  /// In ru, this message translates to:
  /// **'Мета-апгрейды покупаются за очки между боями и сохраняются. Тактические — только внутри боя за ресурсы базы.'**
  String get helpUpgradesBody;

  /// No description provided for @helpDifficultyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сложность'**
  String get helpDifficultyTitle;

  /// No description provided for @helpDifficultyBody.
  ///
  /// In ru, this message translates to:
  /// **'Лёгкая — медленнее AI и чуть быстрее ваш флот. Сложная — агрессивнее чужие. Мета-апгрейды при поражении не сбрасываются.'**
  String get helpDifficultyBody;

  /// No description provided for @settingsSound.
  ///
  /// In ru, this message translates to:
  /// **'Звук'**
  String get settingsSound;

  /// No description provided for @settingsSoundHint.
  ///
  /// In ru, this message translates to:
  /// **'Эффекты боя (ассеты подключаются по мере переноса)'**
  String get settingsSoundHint;

  /// No description provided for @settingsHelp.
  ///
  /// In ru, this message translates to:
  /// **'Справка по игре'**
  String get settingsHelp;

  /// No description provided for @profileGuestLabel.
  ///
  /// In ru, this message translates to:
  /// **'Гость'**
  String get profileGuestLabel;

  /// No description provided for @profileDisplayName.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get profileDisplayName;

  /// No description provided for @profileDisplayNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Как отображать в профиле'**
  String get profileDisplayNameHint;

  /// No description provided for @profileSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get profileSave;

  /// No description provided for @profileMission.
  ///
  /// In ru, this message translates to:
  /// **'Текущая миссия'**
  String get profileMission;

  /// No description provided for @profileScore.
  ///
  /// In ru, this message translates to:
  /// **'Очки'**
  String get profileScore;

  /// No description provided for @profileStarted.
  ///
  /// In ru, this message translates to:
  /// **'Кампания с'**
  String get profileStarted;

  /// No description provided for @profileAccountHint.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт сохраняет прогресс в облаке и открывает рейтинг.'**
  String get profileAccountHint;

  /// No description provided for @profileRegister.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрироваться'**
  String get profileRegister;

  /// No description provided for @profileLogin.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get profileLogin;

  /// No description provided for @profileAccountTitle.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт'**
  String get profileAccountTitle;

  /// No description provided for @profileLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get profileLogout;

  /// No description provided for @profileLogoutSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Вы вышли из аккаунта'**
  String get profileLogoutSuccess;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteAccountTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт?'**
  String get profileDeleteAccountTitle;

  /// No description provided for @profileDeleteAccountBody.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс на сервере и рейтинг будут удалены без возможности восстановления.'**
  String get profileDeleteAccountBody;

  /// No description provided for @profileDeleteAccountConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get profileDeleteAccountConfirm;

  /// No description provided for @profileDeleteAccountSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт удалён'**
  String get profileDeleteAccountSuccess;

  /// No description provided for @progressLeaderboard.
  ///
  /// In ru, this message translates to:
  /// **'Лучшие результаты'**
  String get progressLeaderboard;

  /// No description provided for @leaderboardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Рейтинг'**
  String get leaderboardTitle;

  /// No description provided for @leaderboardEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пока никого в таблице — будьте первым!'**
  String get leaderboardEmpty;

  /// No description provided for @leaderboardLoadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить рейтинг'**
  String get leaderboardLoadFailed;

  /// No description provided for @leaderboardGuestHint.
  ///
  /// In ru, this message translates to:
  /// **'Можешь быть в таблице — зарегистрируйся'**
  String get leaderboardGuestHint;

  /// No description provided for @leaderboardMission.
  ///
  /// In ru, this message translates to:
  /// **'Миссия {mission}'**
  String leaderboardMission(int mission);

  /// No description provided for @authLoginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход'**
  String get authLoginTitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get authRegisterTitle;

  /// No description provided for @authForgotTitle.
  ///
  /// In ru, this message translates to:
  /// **'Забыл пароль'**
  String get authForgotTitle;

  /// No description provided for @authResetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get authResetTitle;

  /// No description provided for @authVerifyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждение email'**
  String get authVerifyTitle;

  /// No description provided for @authEmail.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get authPassword;

  /// No description provided for @authPasswordHint.
  ///
  /// In ru, this message translates to:
  /// **'Минимум 6 символов'**
  String get authPasswordHint;

  /// No description provided for @authNewPassword.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get authNewPassword;

  /// No description provided for @authNick.
  ///
  /// In ru, this message translates to:
  /// **'Ник'**
  String get authNick;

  /// No description provided for @authNickHint.
  ///
  /// In ru, this message translates to:
  /// **'3–20 символов, буквы, цифры, _'**
  String get authNickHint;

  /// No description provided for @authRealName.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get authRealName;

  /// No description provided for @authLoginAction.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get authLoginAction;

  /// No description provided for @authRegisterAction.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрироваться'**
  String get authRegisterAction;

  /// No description provided for @authForgotLink.
  ///
  /// In ru, this message translates to:
  /// **'Забыл пароль'**
  String get authForgotLink;

  /// No description provided for @authForgotAction.
  ///
  /// In ru, this message translates to:
  /// **'Отправить код'**
  String get authForgotAction;

  /// No description provided for @authResetAction.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить пароль'**
  String get authResetAction;

  /// No description provided for @authVerifyAction.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить'**
  String get authVerifyAction;

  /// No description provided for @authVerifyCode.
  ///
  /// In ru, this message translates to:
  /// **'Код из письма'**
  String get authVerifyCode;

  /// No description provided for @authNoAccount.
  ///
  /// In ru, this message translates to:
  /// **'Нет аккаунта?'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт?'**
  String get authHaveAccount;

  /// No description provided for @authBackToLogin.
  ///
  /// In ru, this message translates to:
  /// **'К входу'**
  String get authBackToLogin;

  /// No description provided for @authRegisterHint.
  ///
  /// In ru, this message translates to:
  /// **'Ник виден в рейтинге. Имя — в скобках рядом с ником.'**
  String get authRegisterHint;

  /// No description provided for @authForgotBody.
  ///
  /// In ru, this message translates to:
  /// **'Введите email — отправим код для сброса пароля.'**
  String get authForgotBody;

  /// No description provided for @authVerifyBody.
  ///
  /// In ru, this message translates to:
  /// **'Код отправлен на {email}. Введите его ниже.'**
  String authVerifyBody(String email);

  /// No description provided for @authResetBody.
  ///
  /// In ru, this message translates to:
  /// **'Код отправлен на {email}. Придумайте новый пароль.'**
  String authResetBody(String email);

  /// No description provided for @authVerifySent.
  ///
  /// In ru, this message translates to:
  /// **'Код отправлен на почту'**
  String get authVerifySent;

  /// No description provided for @authResetSent.
  ///
  /// In ru, this message translates to:
  /// **'Код для сброса отправлен'**
  String get authResetSent;

  /// No description provided for @authLoginSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Вы вошли в аккаунт'**
  String get authLoginSuccess;

  /// No description provided for @authRegisterSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт создан'**
  String get authRegisterSuccess;

  /// No description provided for @authResetSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Пароль обновлён — войдите с новым'**
  String get authResetSuccess;

  /// No description provided for @authErrorGeneric.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось выполнить запрос'**
  String get authErrorGeneric;

  /// No description provided for @authErrorEmailExists.
  ///
  /// In ru, this message translates to:
  /// **'Этот email уже зарегистрирован — войдите'**
  String get authErrorEmailExists;

  /// No description provided for @authErrorNickTaken.
  ///
  /// In ru, this message translates to:
  /// **'Этот ник занят'**
  String get authErrorNickTaken;

  /// No description provided for @authErrorEmailSend.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось отправить письмо — попробуйте позже'**
  String get authErrorEmailSend;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In ru, this message translates to:
  /// **'Неверный email или пароль'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorInvalidCode.
  ///
  /// In ru, this message translates to:
  /// **'Неверный или просроченный код'**
  String get authErrorInvalidCode;

  /// No description provided for @authNickChecking.
  ///
  /// In ru, this message translates to:
  /// **'Проверяем ник…'**
  String get authNickChecking;

  /// No description provided for @authNickAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Ник свободен'**
  String get authNickAvailable;

  /// No description provided for @authNickTaken.
  ///
  /// In ru, this message translates to:
  /// **'Ник занят'**
  String get authNickTaken;

  /// No description provided for @authNickTooShort.
  ///
  /// In ru, this message translates to:
  /// **'Ник слишком короткий'**
  String get authNickTooShort;

  /// No description provided for @authNickInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Недопустимые символы в нике'**
  String get authNickInvalid;

  /// No description provided for @authNickReserved.
  ///
  /// In ru, this message translates to:
  /// **'Этот ник зарезервирован'**
  String get authNickReserved;

  /// No description provided for @authMergeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Два сохранения'**
  String get authMergeTitle;

  /// No description provided for @authMergeBody.
  ///
  /// In ru, this message translates to:
  /// **'На устройстве и на сервере есть прогресс. Что оставить?'**
  String get authMergeBody;

  /// No description provided for @authMergeLocal.
  ///
  /// In ru, this message translates to:
  /// **'На устройстве'**
  String get authMergeLocal;

  /// No description provided for @authMergeServer.
  ///
  /// In ru, this message translates to:
  /// **'На сервере'**
  String get authMergeServer;

  /// No description provided for @authMergeMissionScore.
  ///
  /// In ru, this message translates to:
  /// **'Миссия {mission} · очки {score}'**
  String authMergeMissionScore(int mission, int score);

  /// No description provided for @newMissionsBannerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новые миссии!'**
  String get newMissionsBannerTitle;

  /// No description provided for @newMissionsBannerBody.
  ///
  /// In ru, this message translates to:
  /// **'На сервере появились новые уровни — они уже на устройстве, можно играть офлайн.'**
  String get newMissionsBannerBody;

  /// No description provided for @newMissionsBannerAction.
  ///
  /// In ru, this message translates to:
  /// **'На карту'**
  String get newMissionsBannerAction;

  /// No description provided for @newMissionsBannerDismiss.
  ///
  /// In ru, this message translates to:
  /// **'Понятно'**
  String get newMissionsBannerDismiss;

  /// No description provided for @donateTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поддержать'**
  String get donateTitle;

  /// No description provided for @donateBody.
  ///
  /// In ru, this message translates to:
  /// **'Expansion — инди-проект. Ссылка на репозиторий и будущие способы поддержки.'**
  String get donateBody;

  /// No description provided for @donateGithub.
  ///
  /// In ru, this message translates to:
  /// **'GitHub проекта'**
  String get donateGithub;

  /// No description provided for @donateThanks.
  ///
  /// In ru, this message translates to:
  /// **'Спасибо, что играете!'**
  String get donateThanks;

  /// No description provided for @donateOpenFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть ссылку'**
  String get donateOpenFailed;

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
