/// Имя и версия локальной SQLite (контент игры, синк с сервером).
abstract final class GameDatabaseConstants {
  static const String fileName = 'expansion_game.db';

  /// Миграции схемы таблиц ([GameDatabaseMigrations]).
  static const int schemaVersion = 2;

  /// Версия набора контента (сиды из assets). Увеличивать при смене JSON.
  static const int bundledContentVersion = 6;

  static const int campaignMissionCount = 40;
}
