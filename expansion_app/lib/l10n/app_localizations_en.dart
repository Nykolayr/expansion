// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Expansion';

  @override
  String get splashTitleSpace => 'SPACE';

  @override
  String get splashTitleExpansion => 'EXPANSION';

  @override
  String get splashPretext =>
      'In 2222, overpopulation on Earth, famine, and scarce resources forced humanity to settle the Solar System. Then satellites reported that aliens had taken Pluto. Our expansion met theirs. They entrusted you—a former officer—to lead this fight. The fate of humanity is in your hands.';

  @override
  String get splashLoadLabel => 'load...';

  @override
  String get splashBeginGame => 'Start a new game';

  @override
  String get splashMenuProfile => 'Profile';

  @override
  String get splashMenuSettings => 'Settings';

  @override
  String get splashMenuProgress => 'Progress';

  @override
  String get splashMenuNewGame => 'New game';

  @override
  String get splashMenuUpgrades => 'Upgrades';

  @override
  String get splashMenuContinue => 'Continue';

  @override
  String get splashFeatureSoon => 'This section is coming soon.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsReplayIntro => 'Show intro again';

  @override
  String get settingsReplayIntroHint => 'Open the full story screen';

  @override
  String get splashDontShowAgain => 'Don\'t show on next launch';

  @override
  String get introStoryTitle => 'Story';

  @override
  String get mapsTitle => 'Campaign map';

  @override
  String get beginTitle => 'New game';

  @override
  String get battleTitle => 'Battle';

  @override
  String get profileTitle => 'Profile';

  @override
  String get progressTitle => 'Progress';

  @override
  String get screenPlaceholderBody =>
      'This section is under development. Content and logic come in later phases.';

  @override
  String get bootstrapInitFailed =>
      'Could not prepare the local database. Please restart the app.';

  @override
  String get mapsStartBattle => 'Expand';

  @override
  String get mapsDescriptionFallback =>
      'System recon in progress. Prepare for battle.';

  @override
  String get mapsLoadFailed => 'Could not load the campaign map.';

  @override
  String get beginDifficultyHint =>
      'Choose difficulty. It affects alien pace and unpredictability.';

  @override
  String get beginDifficultyEasy => 'Easy';

  @override
  String get beginDifficultyAverage => 'Average';

  @override
  String get beginDifficultyHard => 'Hard';

  @override
  String get beginStartMission => 'Save humanity';

  @override
  String get battleBriefingFallback => 'Capture all enemy bases.';

  @override
  String get battleTapHint =>
      'Tap: your base → target. Line of sight must be clear.';

  @override
  String get battleVictoryTitle => 'Victory';

  @override
  String get battleVictoryBody =>
      'System secured. The next mission is on the map.';

  @override
  String get battleDefeatTitle => 'Defeat';

  @override
  String get battleDefeatBody =>
      'Fleet lost. Try again or lower the difficulty.';

  @override
  String get battleContinue => 'Continue';

  @override
  String battleScenePlaceholder(int sceneId) {
    return 'Mission $sceneId. Battle gameplay — phase 3.';
  }
}
