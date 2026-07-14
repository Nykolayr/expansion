/// Ключи [SharedPreferences] приложения.
abstract final class PrefsKeys {
  /// Показывать вступительный текст и полосу загрузки на splash (legacy `game.isSplash`).
  static const String splashShowIntro = 'splash_show_intro';
  /// Маркер первого запуска после установки (не путать с обновлением).
  static const String appInstallMarker = 'app_install_marker';
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
  static const String guestDebrisTutorialSeen = 'guest_debris_tutorial_seen';
  static const String guestMission1TutorialCompleted =
      'guest_mission1_tutorial_completed';
  static const String guestMapTutorialSeen = 'guest_map_tutorial_seen';
  static const String guestSeenFeatureIntros = 'guest_seen_feature_intros';
  static const String guestCampaignStartedAt = 'guest_campaign_started_at';
  static const String guestCampaignEpilogueSeenForCount =
      'guest_campaign_epilogue_seen_for_count';
  static const String soundEnabled = 'sound_enabled';

  /// Последняя OTA-версия контента, о которой игрок уже видел баннер.
  static const String lastAcknowledgedContentVersion =
      'last_acknowledged_content_version';

  static const String guestAdsRemoved = 'guest_ads_removed';
  static const String guestSupporterTier = 'guest_supporter_tier';
  static const String deviceId = 'device_id';
  static const String adsBattlesSinceInterstitial = 'ads_battles_since_interstitial';
  static const String adsLastInterstitialMillis = 'ads_last_interstitial_millis';
}
