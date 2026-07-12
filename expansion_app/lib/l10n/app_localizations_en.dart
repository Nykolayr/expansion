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
  String get settingsReplayIntroHint =>
      'Show the intro story on the splash screen';

  @override
  String get settingsLanguage => 'Interface language';

  @override
  String get settingsLanguageHint => 'Applies to all screens';

  @override
  String get settingsLanguageRu => 'Russian';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsDifficulty => 'Campaign difficulty';

  @override
  String get settingsDifficultyHint =>
      'Affects alien pace and tactics. Applies to the next battle.';

  @override
  String get battleDefeatHintStreakBody =>
      'You\'ve lost this mission several times in a row. Try lowering the difficulty in Settings — your campaign upgrades stay.';

  @override
  String get battleLowerDifficulty => 'Lower difficulty';

  @override
  String get splashDontShowAgain => 'Don\'t show on next launch';

  @override
  String get introStoryTitle => 'Story';

  @override
  String get campaignEpilogueTitle => 'Victory';

  @override
  String get campaignEpilogueDismiss => 'To the map';

  @override
  String campaignEpilogueText(int missionCount) {
    return 'Commander! Thanks to your leadership alone, we shattered the invaders and secured this star sector. All $missionCount systems in this campaign are ours.\n\nScouts report new routes are open. Dozens of star systems await colonists. Humanity looks into the void with hope again — and once more, it looks to you.\n\nCatch your breath, strengthen your bases, ready the fleet. Expansion continues. This victory is yours.';
  }

  @override
  String get mapsTitle => 'Campaign map';

  @override
  String get beginTitle => 'New game';

  @override
  String get battleTitle => 'Battle';

  @override
  String get battleLayoutNotFound =>
      'Battle layout for this mission was not found.';

  @override
  String get guestDefaultName => 'Guest';

  @override
  String get battlePauseTitle => 'Paused';

  @override
  String get battlePauseContinue => 'Continue';

  @override
  String get battlePauseRestart => 'Restart';

  @override
  String get battlePauseExitMain => 'Exit to main menu';

  @override
  String get profileTitle => 'Profile';

  @override
  String get progressTitle => 'Progress';

  @override
  String get upgradesTitle => 'Upgrades';

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
  String get mapsMissionCompleted => 'Done';

  @override
  String get mapsUnknownSystem => '???????';

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
  String get beginUniverHint => 'Universe (campaign mode)';

  @override
  String get beginUniverClassic => 'Classic';

  @override
  String get beginUniverClassicHint => '40-mission campaign';

  @override
  String get beginUniverGenerated => 'Random';

  @override
  String get beginUniverStrategic => 'Strategic';

  @override
  String get beginUniverComingSoon => 'Coming soon';

  @override
  String get beginResetConfirmTitle => 'Start over?';

  @override
  String get beginResetConfirmBody =>
      'Campaign progress, points, and upgrades will be reset. This cannot be undone.';

  @override
  String get beginResetConfirm => 'Reset and start';

  @override
  String get beginResetCancel => 'Cancel';

  @override
  String get progressDifficulty => 'Difficulty';

  @override
  String get progressUniver => 'Universe';

  @override
  String get battleBriefingFallback => 'Capture all enemy bases.';

  @override
  String get battleDragHint =>
      'Drag from your base to the target. Tap your base for upgrades.';

  @override
  String battleBaseSummary(int ships, int shield, int resources) {
    return 'Ships $ships · Shield $shield · Resources $resources';
  }

  @override
  String get tacticalUpgradeShieldShort => 'Shield';

  @override
  String get tacticalUpgradeBuildShort => 'Build';

  @override
  String get tacticalUpgradeMaxShipsShort => 'Cap';

  @override
  String get battleMeteoriteTutorialTitle => 'Asteroid!';

  @override
  String get battleMeteoriteTutorialBody =>
      'An asteroid crosses the field. On impact it drains the shield first, then destroys ships. Keep your shield up or move fleets off its path.';

  @override
  String get battleMeteoriteTutorialDismiss => 'Got it';

  @override
  String get battleTacticalSwipeHint => 'Swipe down or tap ✕ to close';

  @override
  String get battleTacticalClose => 'Close';

  @override
  String get battleSendFailed =>
      'Cannot send fleet: select your base, wait for flights to finish, or check line of sight.';

  @override
  String get battleTacticalTitle => 'Base upgrades';

  @override
  String battleTacticalResources(int amount) {
    return 'Resources: $amount';
  }

  @override
  String get tacticalUpgradeShield => 'Reinforce shield (+20)';

  @override
  String get tacticalUpgradeBuild => 'Faster production';

  @override
  String get tacticalUpgradeMaxShips => 'Raise ship cap';

  @override
  String battleTacticalBuy(int cost) {
    return '$cost';
  }

  @override
  String get battleTacticalMaxLabel => 'Max';

  @override
  String get battleTacticalSuccess => 'Upgrade applied';

  @override
  String get battleTacticalNotEnough => 'Not enough resources on this base';

  @override
  String get battleTacticalMax => 'Upgrade cap reached';

  @override
  String get battleTacticalBusy =>
      'Wait until fleets or asteroids finish moving';

  @override
  String get battleVictoryTitle => 'Victory';

  @override
  String get battleVictoryBody =>
      'System secured. The next mission is on the map.';

  @override
  String battleVictoryBodyWithScore(int score) {
    return 'System secured. Reward: $score points. Next mission on the map.';
  }

  @override
  String metaUpgradeScore(int score) {
    return 'Points: $score';
  }

  @override
  String get metaUpgradeShipSpeed => 'Fleet speed';

  @override
  String get metaUpgradeShipDurability => 'Attack power';

  @override
  String get metaUpgradeShipBuildSpeed => 'Ship production';

  @override
  String get metaUpgradeResourceIncome => 'Resource income';

  @override
  String get metaUpgradeShield => 'Shield strength';

  @override
  String get metaUpgradeBeginShips => 'Starting ships';

  @override
  String metaUpgradeLevel(int level, int percent) {
    return 'Lv $level (+$percent%)';
  }

  @override
  String metaUpgradeBuy(int cost) {
    return '$cost';
  }

  @override
  String get metaUpgradeMax => 'Max';

  @override
  String get metaUpgradePurchased => 'Upgrade purchased';

  @override
  String get metaUpgradeNotEnough => 'Not enough points';

  @override
  String get progressCurrentMission => 'Current mission';

  @override
  String get progressCompleted => 'Missions completed';

  @override
  String get progressScore => 'Points';

  @override
  String get progressEnemyPower => 'Alien pressure (campaign)';

  @override
  String get battleDefeatTitle => 'Defeat';

  @override
  String get battleDefeatBody =>
      'Fleet lost. Try again or lower the difficulty.';

  @override
  String get battleContinue => 'Continue';

  @override
  String battleVictoryRewardDetail(int base, int bonus, int total) {
    return 'Base: $base + mission: $bonus = $total points.';
  }

  @override
  String get battleVictoryToMap => 'To map';

  @override
  String get battleVictoryToUpgrades => 'Upgrades';

  @override
  String battleVictoryNextMission(int id) {
    return 'Next mission ($id)';
  }

  @override
  String get battleTutorialDragTitle => 'Send a fleet';

  @override
  String get battleTutorialDragBody =>
      'Swipe from your base (blue) to a target. Half the ships on the base will launch.';

  @override
  String get battleTutorialCaptureTitle => 'Capture';

  @override
  String get battleTutorialCaptureBody =>
      'Watch the field: your fleet flies to the target (pulsing ring). After capture, tap the captured base.';

  @override
  String get battleTutorialUpgradeTitle => 'Base upgrades';

  @override
  String get battleTutorialUpgradeBody =>
      'Tap the captured base on the field. Buy an upgrade or tap Got it — next we explain the enemy and the battle goal.';

  @override
  String get battleTutorialGoalTitle => 'Battle goal';

  @override
  String get battleTutorialGoalBody =>
      'Red enemy bases also send fleets and capture your and neutral bases. Win by taking all enemy bases. You lose if you lose all your bases.';

  @override
  String get battleTutorialDismiss => 'Got it';

  @override
  String get battleTutorialSkip => 'Skip';

  @override
  String get battleIntroMediumBaseTitle => 'Medium base';

  @override
  String get battleIntroMediumBaseBody =>
      'Starts with 40 ships, cap 50. Harder to capture than small (20/30).';

  @override
  String get battleIntroLargeBaseTitle => 'Large base';

  @override
  String get battleIntroLargeBaseBody =>
      'Starts with 60 ships, cap 80. Capture last — send a large fleet.';

  @override
  String get battleIntroRichBaseTitle => 'Rich base';

  @override
  String get battleIntroRichBaseBody =>
      '5× resource income. Capture for upgrades. Don\'t send attack fleets from here — keep it as a rear base.';

  @override
  String get battleIntroShieldedBaseTitle => 'Shielded base';

  @override
  String get battleIntroShieldedBaseBody =>
      'Starts with a shield that absorbs hazard damage. Break the shield before destroying ships.';

  @override
  String get battleIntroFactoryBaseTitle => 'Factory base';

  @override
  String get battleIntroFactoryBaseBody =>
      'Builds ships 5× faster (×5) but starts with fewer. Hold it and production ramps up quickly.';

  @override
  String get battleIntroBunkerBaseTitle => 'Bunker base';

  @override
  String get battleIntroBunkerBaseBody =>
      'High ship cap and tough garrison, slower growth. Hard to crack — send a large fleet.';

  @override
  String get battleIntroCometTitle => 'Comet!';

  @override
  String get battleIntroCometBody =>
      'A comet sweeps in on an arc from a field corner. It hits bases and fleets in its path — watch for unpredictable trajectories.';

  @override
  String get battleIntroPulseTitle => 'Energy pulse!';

  @override
  String get battleIntroPulseBody =>
      'A pulse spreads from the center in a cross pattern. Hits bases and fleets on those lines — plan routes carefully.';

  @override
  String get battleIntroDroneTitle => 'Supply drones';

  @override
  String get battleIntroDroneBody =>
      'Periodically reinforce enemy bases with free ships. Pressure enemy bases before drones stack up.';

  @override
  String get battleDebrisTutorialTitle => 'Meteor stream!';

  @override
  String get battleDebrisTutorialBody =>
      'A meteor stream crosses the center of the field. Destroys 80% of fleet and garrison ships in its path and keeps moving — don\'t route ships through the center unless you must.';

  @override
  String metaUpgradeLevelShort(int level) {
    return 'Lv $level';
  }

  @override
  String get mapTutorialTitle => 'Campaign map';

  @override
  String get mapTutorialBody =>
      'Pick a system and tap Expansion to fight. Completed missions can be replayed.';

  @override
  String get mapTutorialDismiss => 'Let\'s go';

  @override
  String get mapTutorialLater => 'Later';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpBattleTitle => 'Battle';

  @override
  String get helpBattleBody =>
      'Swipe between bases to send fleets in a straight line when the path is clear. Capture all enemy bases. Asteroids damage shields and ships.';

  @override
  String get helpMapTitle => 'Map';

  @override
  String get helpMapBody =>
      '40 Classic missions. The current one is marked. Winning unlocks the next system.';

  @override
  String get helpUpgradesTitle => 'Upgrades';

  @override
  String get helpUpgradesBody =>
      'Meta upgrades cost points between battles and persist. Tactical upgrades cost base resources and reset each battle.';

  @override
  String get helpDifficultyTitle => 'Difficulty';

  @override
  String get helpDifficultyBody =>
      'Easy slows the AI and slightly boosts your fleets. Hard makes aliens more aggressive. Meta upgrades are kept on defeat.';

  @override
  String get settingsSound => 'Sound';

  @override
  String get settingsSoundHint =>
      'Battle SFX (assets added as they are ported)';

  @override
  String get settingsHelp => 'Game help';

  @override
  String get profileGuestLabel => 'Guest';

  @override
  String get profileDisplayName => 'Name';

  @override
  String get profileDisplayNameHint => 'Shown in your profile';

  @override
  String get profileSave => 'Save';

  @override
  String get profileMission => 'Current mission';

  @override
  String get profileScore => 'Points';

  @override
  String get profileStarted => 'Campaign since';

  @override
  String get profileAccountHint =>
      'An account saves progress to the cloud and unlocks the leaderboard.';

  @override
  String get profileRegister => 'Sign up';

  @override
  String get profileLogin => 'Sign in';

  @override
  String get profileAccountTitle => 'Account';

  @override
  String get profileLogout => 'Sign out';

  @override
  String get profileLogoutSuccess => 'Signed out';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileDeleteAccountTitle => 'Delete account?';

  @override
  String get profileDeleteAccountBody =>
      'Server progress and leaderboard entry will be permanently removed.';

  @override
  String get profileDeleteAccountConfirm => 'Delete';

  @override
  String get profileDeleteAccountSuccess => 'Account deleted';

  @override
  String get progressLeaderboard => 'Top scores';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get leaderboardEmpty => 'No entries yet — be the first!';

  @override
  String get leaderboardLoadFailed => 'Could not load leaderboard';

  @override
  String get leaderboardGuestHint => 'You could be on the board — sign up';

  @override
  String leaderboardMission(int mission) {
    return 'Mission $mission';
  }

  @override
  String get authLoginTitle => 'Sign in';

  @override
  String get authRegisterTitle => 'Sign up';

  @override
  String get authForgotTitle => 'Forgot password';

  @override
  String get authResetTitle => 'New password';

  @override
  String get authVerifyTitle => 'Verify email';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordHint => 'At least 6 characters';

  @override
  String get authNewPassword => 'New password';

  @override
  String get authNick => 'Nickname';

  @override
  String get authNickHint => '3–20 chars: letters, digits, _';

  @override
  String get authRealName => 'Name';

  @override
  String get authLoginAction => 'Sign in';

  @override
  String get authRegisterAction => 'Sign up';

  @override
  String get authForgotLink => 'Forgot password';

  @override
  String get authForgotAction => 'Send code';

  @override
  String get authResetAction => 'Save password';

  @override
  String get authVerifyAction => 'Confirm';

  @override
  String get authVerifyCode => 'Code from email';

  @override
  String get authNoAccount => 'No account?';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get authRegisterHint =>
      'Nickname appears on the leaderboard. Name is shown in parentheses.';

  @override
  String get authForgotBody => 'Enter your email — we\'ll send a reset code.';

  @override
  String authVerifyBody(String email) {
    return 'Code sent to $email. Enter it below.';
  }

  @override
  String authResetBody(String email) {
    return 'Code sent to $email. Choose a new password.';
  }

  @override
  String get authVerifySent => 'Verification code sent';

  @override
  String get authResetSent => 'Reset code sent';

  @override
  String get authLoginSuccess => 'Signed in';

  @override
  String get authRegisterSuccess => 'Account created';

  @override
  String get authResetSuccess => 'Password updated — sign in with the new one';

  @override
  String get authErrorGeneric => 'Request failed';

  @override
  String get authErrorEmailExists =>
      'This email is already registered — sign in';

  @override
  String get authErrorNickTaken => 'This nickname is taken';

  @override
  String get authErrorEmailSend => 'Could not send email — try again later';

  @override
  String get authErrorInvalidCredentials => 'Invalid email or password';

  @override
  String get authErrorInvalidCode => 'Invalid or expired code';

  @override
  String get authNickChecking => 'Checking nickname…';

  @override
  String get authNickAvailable => 'Nickname available';

  @override
  String get authNickTaken => 'Nickname taken';

  @override
  String get authNickTooShort => 'Nickname too short';

  @override
  String get authNickInvalid => 'Invalid characters in nickname';

  @override
  String get authNickReserved => 'This nickname is reserved';

  @override
  String get authMergeTitle => 'Two saves found';

  @override
  String get authMergeBody =>
      'Progress exists on this device and on the server. Which one to keep?';

  @override
  String get authMergeLocal => 'On device';

  @override
  String get authMergeServer => 'On server';

  @override
  String authMergeMissionScore(int mission, int score) {
    return 'Mission $mission · score $score';
  }

  @override
  String get newMissionsBannerTitle => 'New missions!';

  @override
  String get newMissionsBannerBody =>
      'New levels are on your device — play offline anytime.';

  @override
  String get newMissionsBannerAction => 'Open map';

  @override
  String get newMissionsBannerDismiss => 'Got it';

  @override
  String get donateTitle => 'Support';

  @override
  String get donateBody =>
      'Expansion is an indie project. Repository link and more ways to support coming later.';

  @override
  String get donateGithub => 'Project on GitHub';

  @override
  String get donateThanks => 'Thanks for playing!';

  @override
  String get donateOpenFailed => 'Could not open the link';

  @override
  String battleScenePlaceholder(int sceneId) {
    return 'Mission $sceneId. Battle gameplay — phase 3.';
  }
}
