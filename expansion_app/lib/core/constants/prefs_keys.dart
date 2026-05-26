/// Ключи [SharedPreferences] приложения.
abstract final class PrefsKeys {
  /// Показывать вступительный текст и полосу загрузки на splash (legacy `game.isSplash`).
  static const String splashShowIntro = 'splash_show_intro';

  static const String guestMapClassic = 'guest_map_classic';
  static const String guestScoreClassic = 'guest_score_classic';
  static const String guestDifficulty = 'guest_difficulty';
  static const String guestFirstBattleCompleted = 'guest_first_battle_completed';
  static const String guestDisplayName = 'guest_display_name';
  static const String guestMetaProgress = 'guest_meta_progress';
}
