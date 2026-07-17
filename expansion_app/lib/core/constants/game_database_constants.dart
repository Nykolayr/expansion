/// Имя и версия локальной SQLite (контент игры, синк с сервером).
abstract final class GameDatabaseConstants {
  static const String fileName = 'expansion_game.db';

  /// Миграции схемы таблиц ([GameDatabaseMigrations]).
  static const int schemaVersion = 2;

  /// Версия набора контента **в APK (offline-baseline)**. Увеличивать только при смене
  /// bundled м1–м5. Новые миссии м6+ — OTA на сервере, см. docs/campaign-content-ota.md.
  static const int bundledContentVersion = 6;

  static const int campaignMissionCount = 50;
}
