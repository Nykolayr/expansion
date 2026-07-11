/// Какие hazard'ы активны на миссии (по sceneId).
abstract final class BattleMissionHazards {
  static bool asteroidsEnabled(int sceneId) {
    if (sceneId == 3 ||
        sceneId == 5 ||
        sceneId == 7 ||
        sceneId == 9 ||
        sceneId == 11 ||
        sceneId == 13 ||
        sceneId == 15) {
      return false;
    }
    return sceneId >= 1;
  }

  static bool debrisEnabled(int sceneId) => sceneId == 5;

  static bool cometEnabled(int sceneId) => sceneId == 3;

  static bool pulseEnabled(int sceneId) => sceneId == 7;

  static bool droneEnabled(int sceneId) => sceneId == 9;

  static bool mineEnabled(int sceneId) => sceneId == 11;

  static bool solarWindEnabled(int sceneId) => sceneId == 13;

  static bool wormholeEnabled(int sceneId) => sceneId == 15;

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

  static int cometSpawnIntervalTicks(int sceneId) => sceneId == 3 ? 1000 : 1200;

  static int pulseSpawnIntervalTicks(int sceneId) => sceneId == 7 ? 950 : 1200;

  static int droneReinforcementIntervalTicks(int sceneId) =>
      sceneId == 9 ? 850 : 1200;

  static int droneReinforcementShips(int sceneId) => sceneId == 9 ? 8 : 0;

  static int mineRespawnIntervalTicks(int sceneId) => sceneId == 11 ? 1400 : 1200;

  static int solarWindSpawnIntervalTicks(int sceneId) =>
      sceneId == 13 ? 900 : 1200;

  static int wormholeSpawnIntervalTicks(int sceneId) =>
      sceneId == 15 ? 1100 : 1200;

  /// Узкий коридор м5 — обломки летят по y=4.
  static const int debrisCorridorRow = 4;

  static const int cometCorridorColumn = 3;

  static const int pulseOriginX = 3;
  static const int pulseOriginY = 4;

  static const List<(int x, int y)> mineCells = [(2, 3), (4, 3)];

  static const List<int> solarWindRows = [2, 4, 6];

  /// Мощность на маркере (катастрофа; урон — по доле, не по power).
  static const int debrisDisplayPowerMin = 60;
  static const int debrisDisplayPowerMax = 80;

  /// Доля кораблей, уничтожаемая при пролёте (флот и гарнизон базы).
  static const double debrisShipLossFraction = 0.8;

  static const int cometPower = 35;
  static const int pulsePower = 28;
  static const int minePower = 40;
  static const int solarWindPower = 55;
  static const int wormholePower = 32;
}
