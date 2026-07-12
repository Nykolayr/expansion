import 'package:expansion/domain/enums/battle_hazard_kind.dart';

/// Какие hazard'ы активны на миссии (по sceneId).
abstract final class BattleMissionHazards {
  /// Основной «эксклюзивный» hazard миссии (если есть). `null` — обычные астероиды.
  static BattleHazardKind? exclusiveKind(int sceneId) {
    return switch (sceneId) {
      3 || 17 || 23 || 29 || 36 => BattleHazardKind.comet,
      5 || 19 || 27 || 35 => BattleHazardKind.debris,
      7 || 22 || 28 || 34 || 38 => BattleHazardKind.pulse,
      11 || 21 || 26 || 31 || 37 => BattleHazardKind.mine,
      13 || 24 || 33 || 39 => BattleHazardKind.solarWind,
      15 || 25 || 32 || 40 => BattleHazardKind.wormhole,
      _ => null,
    };
  }

  static bool asteroidsEnabled(int sceneId) {
    if (sceneId == 9 || sceneId == 20 || sceneId == 30) return false;
    if (exclusiveKind(sceneId) != null && sceneId != 40) return false;
    return sceneId >= 1;
  }

  static bool debrisEnabled(int sceneId) =>
      exclusiveKind(sceneId) == BattleHazardKind.debris;

  static bool cometEnabled(int sceneId) =>
      exclusiveKind(sceneId) == BattleHazardKind.comet;

  static bool pulseEnabled(int sceneId) =>
      exclusiveKind(sceneId) == BattleHazardKind.pulse;

  static bool droneEnabled(int sceneId) =>
      sceneId == 9 || sceneId == 20 || sceneId == 30;

  static bool mineEnabled(int sceneId) =>
      exclusiveKind(sceneId) == BattleHazardKind.mine;

  static bool solarWindEnabled(int sceneId) =>
      exclusiveKind(sceneId) == BattleHazardKind.solarWind;

  static bool wormholeEnabled(int sceneId) =>
      exclusiveKind(sceneId) == BattleHazardKind.wormhole;

  static int asteroidSpawnIntervalTicks(int sceneId) {
    return switch (sceneId) {
      1 => 1200,
      2 => 1500,
      <= 3 => 1200,
      <= 10 => 1050,
      <= 15 => 950,
      <= 25 => 850,
      <= 35 => 780,
      40 => 650,
      _ => 720,
    };
  }

  static int debrisSpawnIntervalTicks(int sceneId) {
    return switch (sceneId) {
      5 => 1100,
      19 || 27 || 35 => 950,
      _ => 1200,
    };
  }

  static int cometSpawnIntervalTicks(int sceneId) {
    return switch (sceneId) {
      3 => 1000,
      17 || 23 || 29 => 920,
      36 => 880,
      _ => 1200,
    };
  }

  static int pulseSpawnIntervalTicks(int sceneId) {
    return switch (sceneId) {
      7 => 950,
      22 || 28 || 34 => 880,
      38 => 820,
      _ => 1200,
    };
  }

  static int droneReinforcementIntervalTicks(int sceneId) {
    return switch (sceneId) {
      9 => 380,
      20 => 420,
      30 => 360,
      _ => 1200,
    };
  }

  static int droneReinforcementShips(int sceneId) {
    return switch (sceneId) {
      9 => 10,
      20 => 12,
      30 => 14,
      _ => 0,
    };
  }

  static int mineRespawnIntervalTicks(int sceneId) {
    return switch (sceneId) {
      11 => 1400,
      21 || 26 || 31 => 1200,
      37 => 1050,
      _ => 1200,
    };
  }

  static int solarWindSpawnIntervalTicks(int sceneId) {
    return switch (sceneId) {
      13 => 900,
      24 || 33 => 820,
      39 => 760,
      _ => 1200,
    };
  }

  static int wormholeSpawnIntervalTicks(int sceneId) {
    return switch (sceneId) {
      15 => 1100,
      25 || 32 => 980,
      40 => 900,
      _ => 1200,
    };
  }

  /// Узкий коридор — обломки летят по этой строке.
  static int debrisCorridorRow(int sceneId) {
    return switch (sceneId) {
      5 => 4,
      19 => 3,
      27 => 5,
      35 => 4,
      _ => 4,
    };
  }

  /// Устарело: комета летит по дуге от углов (см. `_randomCometArc` в движке).
  @Deprecated('Comet uses corner arcs, not a fixed column')
  static int cometCorridorColumn(int sceneId) {
    return switch (sceneId) {
      3 => 3,
      17 || 23 || 29 || 36 => 3,
      _ => 3,
    };
  }

  static int pulseOriginX(int sceneId) => 3;

  static int pulseOriginY(int sceneId) {
    return switch (sceneId) {
      7 || 22 || 28 => 4,
      34 || 38 => 3,
      _ => 4,
    };
  }

  static List<(int x, int y)> mineCells(int sceneId) {
    return switch (sceneId) {
      11 => [(2, 3), (4, 3)],
      21 => [(2, 4), (4, 4)],
      26 => [(3, 3), (3, 5)],
      31 => [(1, 4), (5, 4)],
      37 => [(2, 3), (4, 5)],
      _ => [(2, 3), (4, 3)],
    };
  }

  static const List<int> solarWindRows = [2, 4, 6];

  static const int debrisDisplayPowerMin = 60;
  static const int debrisDisplayPowerMax = 80;
  static const double debrisShipLossFraction = 0.8;

  static int cometPower(int sceneId) => sceneId >= 20 ? 38 : 35;

  static int pulsePower(int sceneId) => sceneId >= 30 ? 32 : 28;

  static int minePower(int sceneId) => sceneId >= 25 ? 45 : 40;

  static int solarWindPower(int sceneId) => sceneId >= 30 ? 60 : 55;

  static int wormholePower(int sceneId) => sceneId >= 35 ? 36 : 32;
}
