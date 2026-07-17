import 'package:expansion/domain/enums/battle_hazard_kind.dart';

/// Какие hazard'ы активны на миссии (по sceneId).
abstract final class BattleMissionHazards {
  /// Основной «эксклюзивный» hazard миссии (если есть). `null` — обычные астероиды.
  static BattleHazardKind? exclusiveKind(int sceneId) {
    return switch (sceneId) {
      3 || 17 || 23 || 29 || 36 || 42 || 49 => BattleHazardKind.comet,
      5 || 19 || 27 || 35 || 43 => BattleHazardKind.debris,
      7 || 22 || 28 || 34 || 38 || 46 => BattleHazardKind.pulse,
      11 || 21 || 26 || 31 || 37 || 45 => BattleHazardKind.mine,
      13 || 24 || 33 || 39 || 47 => BattleHazardKind.solarWind,
      15 || 25 || 32 || 40 || 48 => BattleHazardKind.wormhole,
      _ => null,
    };
  }

  /// Миссия, на которой hazard впервые показывается в кампании.
  static int introMission(BattleHazardKind kind) {
    return switch (kind) {
      BattleHazardKind.asteroid => 1,
      BattleHazardKind.comet => 3,
      BattleHazardKind.debris => 5,
      BattleHazardKind.pulse => 7,
      BattleHazardKind.mine => 11,
      BattleHazardKind.solarWind => 13,
      BattleHazardKind.wormhole => 15,
      BattleHazardKind.drone => 9,
    };
  }

  static bool _isPrimaryMission(int sceneId, BattleHazardKind kind) {
    return switch (kind) {
      BattleHazardKind.asteroid => exclusiveKind(sceneId) == null,
      _ => exclusiveKind(sceneId) == kind,
    };
  }

  static bool _appearsAsSecondary(int sceneId, BattleHazardKind kind) {
    if (sceneId < introMission(kind)) return false;
    return !_isPrimaryMission(sceneId, kind);
  }

  static bool _hazardActive(int sceneId, BattleHazardKind kind) {
    if (sceneId < introMission(kind)) return false;
    return _isPrimaryMission(sceneId, kind) || _appearsAsSecondary(sceneId, kind);
  }

  static bool asteroidsEnabled(int sceneId) {
    if (sceneId == 9 ||
        sceneId == 20 ||
        sceneId == 30 ||
        sceneId == 44 ||
        sceneId == 50) {
      return false;
    }
    return _hazardActive(sceneId, BattleHazardKind.asteroid);
  }

  static bool debrisEnabled(int sceneId) =>
      _hazardActive(sceneId, BattleHazardKind.debris);

  static bool cometEnabled(int sceneId) =>
      _hazardActive(sceneId, BattleHazardKind.comet);

  static bool pulseEnabled(int sceneId) =>
      _hazardActive(sceneId, BattleHazardKind.pulse);

  static bool droneEnabled(int sceneId) =>
      sceneId == 9 ||
      sceneId == 20 ||
      sceneId == 30 ||
      sceneId == 44 ||
      sceneId == 50;

  static bool mineEnabled(int sceneId) =>
      _hazardActive(sceneId, BattleHazardKind.mine);

  static bool solarWindEnabled(int sceneId) =>
      _hazardActive(sceneId, BattleHazardKind.solarWind);

  static bool wormholeEnabled(int sceneId) =>
      _hazardActive(sceneId, BattleHazardKind.wormhole);

  static int _secondaryInterval(int primaryTicks) =>
      (primaryTicks * 2.6).round().clamp(primaryTicks + 500, 4200);

  static int asteroidSpawnIntervalTicks(int sceneId) {
    final primary = switch (sceneId) {
      1 => 1200,
      2 => 1500,
      <= 3 => 1200,
      <= 10 => 1050,
      <= 15 => 950,
      <= 25 => 850,
      <= 35 => 780,
      40 => 650,
      41 => 1100,
      _ => 720,
    };
    if (_appearsAsSecondary(sceneId, BattleHazardKind.asteroid)) {
      return _secondaryInterval(primary);
    }
    return primary;
  }

  static int debrisSpawnIntervalTicks(int sceneId) {
    final primary = switch (sceneId) {
      5 => 1100,
      19 || 27 || 35 || 43 => 950,
      _ => 1200,
    };
    if (_appearsAsSecondary(sceneId, BattleHazardKind.debris)) {
      return _secondaryInterval(primary);
    }
    return primary;
  }

  static int cometSpawnIntervalTicks(int sceneId) {
    final primary = switch (sceneId) {
      3 => 1000,
      17 || 23 || 29 => 920,
      36 || 42 => 880,
      49 => 860,
      _ => 1200,
    };
    if (_appearsAsSecondary(sceneId, BattleHazardKind.comet)) {
      return _secondaryInterval(primary);
    }
    return primary;
  }

  static int pulseSpawnIntervalTicks(int sceneId) {
    final primary = switch (sceneId) {
      7 => 950,
      22 || 28 || 34 => 880,
      38 || 46 => 820,
      _ => 1200,
    };
    if (_appearsAsSecondary(sceneId, BattleHazardKind.pulse)) {
      return _secondaryInterval(primary);
    }
    return primary;
  }

  static int droneReinforcementIntervalTicks(int sceneId) {
    return switch (sceneId) {
      9 => 380,
      20 => 420,
      30 => 360,
      44 => 400,
      50 => 340,
      _ => 1200,
    };
  }

  static int droneReinforcementShips(int sceneId) {
    return switch (sceneId) {
      9 => 10,
      20 => 12,
      30 => 14,
      44 => 12,
      50 => 15,
      _ => 0,
    };
  }

  static int mineRespawnIntervalTicks(int sceneId) {
    final primary = switch (sceneId) {
      11 => 1400,
      21 || 26 || 31 => 1200,
      37 || 45 => 1050,
      49 => 1000,
      _ => 1200,
    };
    if (_appearsAsSecondary(sceneId, BattleHazardKind.mine) &&
        sceneId != 49) {
      return _secondaryInterval(primary);
    }
    return primary;
  }

  static int solarWindSpawnIntervalTicks(int sceneId) {
    final primary = switch (sceneId) {
      13 => 900,
      24 || 33 => 820,
      39 || 47 => 760,
      _ => 1200,
    };
    if (_appearsAsSecondary(sceneId, BattleHazardKind.solarWind)) {
      return _secondaryInterval(primary);
    }
    return primary;
  }

  static int wormholeSpawnIntervalTicks(int sceneId) {
    final primary = switch (sceneId) {
      15 => 1100,
      25 || 32 => 980,
      40 || 48 => 900,
      _ => 1200,
    };
    if (_appearsAsSecondary(sceneId, BattleHazardKind.wormhole)) {
      return _secondaryInterval(primary);
    }
    return primary;
  }

  /// Узкий коридор — обломки летят по этой строке.
  static int debrisCorridorRow(int sceneId) {
    return switch (sceneId) {
      5 => 4,
      19 => 3,
      27 => 5,
      35 || 43 => 4,
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
      34 || 38 || 46 => 3,
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
      45 => [(2, 3), (4, 5)],
      49 => [(2, 4), (3, 3), (4, 5)],
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
