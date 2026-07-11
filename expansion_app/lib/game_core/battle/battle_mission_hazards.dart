/// Какие hazard'ы активны на миссии (по sceneId).
abstract final class BattleMissionHazards {
  /// На м5 — только обломки (новый hazard миссии).
  static bool asteroidsEnabled(int sceneId) => sceneId >= 1 && sceneId != 5;

  static bool debrisEnabled(int sceneId) => sceneId == 5;

  static int asteroidSpawnIntervalTicks(int sceneId) {
    return switch (sceneId) {
      1 => 1200,
      2 => 1500,
      <= 3 => 1200,
      <= 10 => 1050,
      _ => 900,
    };
  }

  static int debrisSpawnIntervalTicks(int sceneId) {
    return switch (sceneId) {
      5 => 1100,
      _ => 1200,
    };
  }

  /// Узкий коридор м5 — обломки летят по y=4.
  static const int debrisCorridorRow = 4;

  /// Мощность на маркере (катастрофа; урон — по доле, не по power).
  static const int debrisDisplayPowerMin = 60;
  static const int debrisDisplayPowerMax = 80;

  /// Доля кораблей, уничтожаемая при пролёте (флот и гарнизон базы).
  static const double debrisShipLossFraction = 0.8;
}
