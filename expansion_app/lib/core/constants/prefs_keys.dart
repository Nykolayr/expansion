/// Ключи [SharedPreferences] приложения.
abstract final class PrefsKeys {
  /// Показывать вступительный текст и полосу загрузки на splash (legacy `game.isSplash`).
  static const String splashShowIntro = 'splash_show_intro';
  static const String appLocale = 'app_locale';

  static const String guestMapClassic = 'guest_map_classic';
  static const String guestScoreClassic = 'guest_score_classic';
  static const String guestDifficulty = 'guest_difficulty';
  static const String guestUniverKind = 'guest_univer_kind';
  static const String guestFirstBattleCompleted = 'guest_first_battle_completed';
  static const String guestDisplayName = 'guest_display_name';
  static const String guestMetaProgress = 'guest_meta_progress';
  static const String guestDefeatStreakSceneId = 'guest_defeat_streak_scene_id';
  static const String guestDefeatStreakCount = 'guest_defeat_streak_count';
  static const String guestAsteroidTutorialSeen = 'guest_asteroid_tutorial_seen';
}
