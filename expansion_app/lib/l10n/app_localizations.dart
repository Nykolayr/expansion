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

  /// No description provided for @battleBriefingFallback.
  ///
  /// In ru, this message translates to:
  /// **'Захватите все вражеские базы.'**
  String get battleBriefingFallback;

  /// No description provided for @battleTapHint.
  ///
  /// In ru, this message translates to:
  /// **'Тап: своя база → цель. Нужна прямая линия без препятствий.'**
  String get battleTapHint;

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
