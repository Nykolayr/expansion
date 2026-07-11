import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/logging/app_log.dart';

/// Сброс онбординга на чистой установке (без прогресса гостя).
///
/// `flutter clean` не очищает prefs на устройстве — только удаление приложения
/// или «Очистить данные». Auto Backup отключён в AndroidManifest.
abstract final class FreshInstallGuard {
  static Future<void> applyIfNeeded(SharedPreferences prefs) async {
    await _migrateLegacySplashKey(prefs);

    final marker = prefs.getString(PrefsKeys.appInstallMarker);
    final hasProgress = _hasGuestProgress(prefs);

    if (marker == null) {
      await prefs.setString(PrefsKeys.appInstallMarker, '1');
      if (!hasProgress) {
        await _resetOnboardingPrefs(prefs);
        AppLog.trace('fresh install: intro and tutorials reset', tag: 'Prefs');
      } else {
        AppLog.trace('install marker set, guest progress kept', tag: 'Prefs');
      }
    }
  }

  static Future<void> _migrateLegacySplashKey(SharedPreferences prefs) async {
    if (!prefs.containsKey('game.isSplash')) return;
    final legacy = prefs.getBool('game.isSplash') ?? true;
    await prefs.setBool(PrefsKeys.splashShowIntro, legacy);
    await prefs.remove('game.isSplash');
    AppLog.trace('migrated legacy game.isSplash -> splash_show_intro', tag: 'Prefs');
  }

  static bool _hasGuestProgress(SharedPreferences prefs) {
    return prefs.getBool(PrefsKeys.guestFirstBattleCompleted) == true ||
        (prefs.getInt(PrefsKeys.guestMapClassic) ?? 1) > 1 ||
        (prefs.getInt(PrefsKeys.guestScoreClassic) ?? 0) > 0 ||
        (prefs.getString(PrefsKeys.guestMetaProgress)?.isNotEmpty ?? false);
  }

  static Future<void> _resetOnboardingPrefs(SharedPreferences prefs) async {
    await prefs.setBool(PrefsKeys.splashShowIntro, true);
    await prefs.setBool(PrefsKeys.guestMission1TutorialCompleted, false);
    await prefs.setBool(PrefsKeys.guestMapTutorialSeen, false);
    await prefs.setBool(PrefsKeys.guestAsteroidTutorialSeen, false);
    await prefs.setBool(PrefsKeys.guestDebrisTutorialSeen, false);
  }
}
