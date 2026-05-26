/// Имя и версия локальной SQLite (контент игры, синк с сервером — фаза 2+).
abstract final class GameDatabaseConstants {
  static const String fileName = 'expansion_game.db';

  /// Таблицы добавляются в [GameDatabase.onCreate] при росте схемы.
  static const int schemaVersion = 1;
}
