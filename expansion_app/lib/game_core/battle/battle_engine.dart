import 'dart:convert';
import 'dart:math';

import 'package:expansion/domain/entities/battle_asteroid.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_fleet.dart';
import 'package:expansion/domain/entities/battle_layout.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/domain/entities/meta_battle_bonuses.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/domain/enums/placement_role.dart';
import 'package:expansion/domain/enums/tactical_upgrade_type.dart';
import 'package:expansion/game_core/battle/battle_line_of_sight.dart';
import 'package:expansion/game_core/battle/tactical_upgrade_result.dart';

enum BattleOutcome { playerWin, playerLose }

/// Правила боя (без Flutter). Флоты летят по тикам, затем разрешается бой.
class BattleEngine {
  BattleEngine({
    required this.sceneId,
    required List<BattleBase> bases,
    required this.gridRows,
    required this.gridCols,
    this.bonuses = MetaBattleBonuses.none,
  })  : _bases = List.of(bases),
        _fleets = [],
        _asteroids = [];

  factory BattleEngine.fromLayout(
    BattleLayout layout, {
    MetaBattleBonuses bonuses = MetaBattleBonuses.none,
  }) {
    var nextId = 0;
    final bases = <BattleBase>[];

    for (final placed in layout.placements) {
      final side = _sideForRole(placed.role);
      final stats = _parseStats(placed.statsJson);
      var ships = stats.ships;
      if (side == BattleSide.player &&
          placed.role == PlacementRole.playerMain &&
          bonuses.beginShipsBonus > 0) {
        ships += bonuses.beginShipsBonus;
      }

      var resources = 0.0;
      if (side == BattleSide.player && placed.role == PlacementRole.playerMain) {
        resources = 120;
      }

      bases.add(
        BattleBase(
          id: nextId++,
          x: placed.position.x,
          y: placed.position.y,
          side: side,
          ships: ships,
          shield: stats.shield,
          maxShips: stats.maxShips,
          neutralKind: placed.neutralKind,
          resources: resources,
          speedBuild: stats.speedBuild,
          speedResources: stats.speedResources,
        ),
      );
    }

    return BattleEngine(
      sceneId: layout.sceneId,
      bases: bases,
      gridRows: layout.gridRows,
      gridCols: layout.gridCols,
      bonuses: bonuses,
    );
  }

  final int sceneId;
  final int gridRows;
  final int gridCols;
  final MetaBattleBonuses bonuses;
  final List<BattleBase> _bases;
  final List<BattleFleet> _fleets;
  final List<BattleAsteroid> _asteroids;
  int _tick = 0;
  int _nextFleetId = 1;
  int _nextAsteroidId = 1;
  int _asteroidSpawnCounter = 0;
  Random? _random;

  static const int _asteroidSpawnIntervalTicks = 500;
  static const double _asteroidProgressPerTick = 0.025;

  void bindRandom(Random random) => _random = random;

  static const double _baseFleetProgressPerTick = 0.06;

  double get _fleetProgressPerTick =>
      _baseFleetProgressPerTick * bonuses.fleetSpeed;

  static const double _resourceIncomePerTick = 0.12;
  static const int _tacticalBaseCost = 80;

  BattleSnapshot snapshot() => BattleSnapshot(
        sceneId: sceneId,
        tick: _tick,
        bases: List.unmodifiable(_bases),
        fleets: List.unmodifiable(_fleets),
        asteroids: List.unmodifiable(_asteroids),
        gridRows: gridRows,
        gridCols: gridCols,
      );

  bool canSendFleet(int fromId, int toId, {BattleSide? requiredSide}) {
    final from = _base(fromId);
    final to = _base(toId);
    if (from == null || to == null) return false;
    if (requiredSide != null && from.side != requiredSide) return false;
    if (from.ships <= 1) return false;
    return BattleLineOfSight.isClear(snapshot(), from, to);
  }

  bool sendFleet(int fromId, int toId, {BattleSide? requiredSide}) {
    if (!canSendFleet(fromId, toId, requiredSide: requiredSide)) {
      return false;
    }
    final from = _base(fromId)!;
    final fleetSize = from.ships;
    _updateBase(fromId, from.copyWith(ships: 0));
    _fleets.add(
      BattleFleet(
        id: _nextFleetId++,
        fromBaseId: fromId,
        toBaseId: toId,
        ships: fleetSize,
        side: from.side,
        progress: 0,
      ),
    );
    return true;
  }

  void tick() {
    _tick++;
    _advanceFleets();
    _advanceAsteroids();
    _maybeSpawnAsteroid();
    _economyTick();
  }

  void _economyTick() {
    for (var i = 0; i < _bases.length; i++) {
      var base = _bases[i];
      if (base.side == BattleSide.neutral) continue;

      final incomeMul =
          base.side == BattleSide.player ? bonuses.resourceIncome : 1.0;
      base = base.copyWith(
        resources:
            base.resources + base.speedResources * _resourceIncomePerTick * incomeMul,
      );

      if (base.ships < base.maxShips) {
        final growthMul =
            base.side == BattleSide.player ? bonuses.growthSpeed : 1.0;
        final threshold =
            (12 / (base.speedBuild * growthMul)).round().clamp(4, 28);
        var acc = base.growthAccumulator + 1;
        if (acc >= threshold) {
          base = base.copyWith(ships: base.ships + 1, growthAccumulator: 0);
        } else {
          base = base.copyWith(growthAccumulator: acc);
        }
      }

      _bases[i] = base;
    }
  }

  int tacticalUpgradeCost(BattleBase base, TacticalUpgradeType type) {
    if (base.isTacticalMaxed(type)) return 0;
    return _tacticalBaseCost * (1 << base.tacticalLevelFor(type));
  }

  TacticalUpgradeResult applyTacticalUpgrade(
    int baseId,
    TacticalUpgradeType type,
  ) {
    if (_fleets.isNotEmpty || _asteroids.isNotEmpty) {
      return TacticalUpgradeResult.busy;
    }

    final base = _base(baseId);
    if (base == null) return TacticalUpgradeResult.invalidBase;
    if (base.side != BattleSide.player) return TacticalUpgradeResult.notPlayerBase;
    if (base.isTacticalMaxed(type)) return TacticalUpgradeResult.maxLevel;

    final cost = tacticalUpgradeCost(base, type);
    if (base.resources < cost) return TacticalUpgradeResult.notEnoughResources;

    final updated = switch (type) {
      TacticalUpgradeType.shield => base.copyWith(
          resources: base.resources - cost,
          shield: base.shield + 20,
          shieldUpgradeLevel: base.shieldUpgradeLevel + 1,
        ),
      TacticalUpgradeType.buildSpeed => base.copyWith(
          resources: base.resources - cost,
          speedBuild: base.speedBuild + 0.05,
          buildUpgradeLevel: base.buildUpgradeLevel + 1,
        ),
      TacticalUpgradeType.maxShips => base.copyWith(
          resources: base.resources - cost,
          maxShips: base.maxShips + 35,
          maxShipsUpgradeLevel: base.maxShipsUpgradeLevel + 1,
        ),
    };

    _updateBase(baseId, updated);
    return TacticalUpgradeResult.success;
  }

  void _maybeSpawnAsteroid() {
    final rng = _random;
    if (rng == null) return;
    _asteroidSpawnCounter++;
    if (_asteroidSpawnCounter < _asteroidSpawnIntervalTicks) return;
    _asteroidSpawnCounter = 0;

    final fromEdge = rng.nextInt(4);
    final toEdge = (fromEdge + 2) % 4;
    final from = _cellOnEdge(fromEdge, rng);
    final to = _cellOnEdge(toEdge, rng);
    final power = 20 + rng.nextInt(16);
    final visualIndex = rng.nextInt(6) + 1;

    _asteroids.add(
      BattleAsteroid(
        id: _nextAsteroidId++,
        fromX: from.$1,
        fromY: from.$2,
        toX: to.$1,
        toY: to.$2,
        power: power,
        visualIndex: visualIndex,
      ),
    );
  }

  void _advanceAsteroids() {
    final removeIds = <int>{};

    for (var i = 0; i < _asteroids.length; i++) {
      final ast = _asteroids[i];
      final nextProgress = ast.progress + _asteroidProgressPerTick;
      if (nextProgress >= 1) {
        removeIds.add(ast.id);
        continue;
      }

      final updated = ast.copyWith(progress: nextProgress);
      _asteroids[i] = updated;

      final cell = _asteroidCell(updated);
      final base = _baseAtCell(cell.$1, cell.$2);
      if (base != null) {
        _applyAsteroidHit(base.id, updated.power);
        removeIds.add(updated.id);
      }
    }

    if (removeIds.isNotEmpty) {
      _asteroids.removeWhere((a) => removeIds.contains(a.id));
    }
  }

  (int x, int y) _asteroidCell(BattleAsteroid ast) {
    final t = ast.progress.clamp(0.0, 1.0);
    final x = (ast.fromX + (ast.toX - ast.fromX) * t).round();
    final y = (ast.fromY + (ast.toY - ast.fromY) * t).round();
    return (x.clamp(1, gridCols), y.clamp(1, gridRows));
  }

  void _applyAsteroidHit(int baseId, int power) {
    final base = _base(baseId);
    if (base == null) return;

    var remaining = power.toDouble();
    var shield = base.shield;

    if (shield > 0) {
      if (shield >= remaining) {
        _updateBase(baseId, base.copyWith(shield: shield - remaining));
        return;
      }
      remaining -= shield;
      shield = 0;
    }

    final ships = base.ships.toDouble();
    if (ships > remaining) {
      _updateBase(
        baseId,
        base.copyWith(shield: 0, ships: (ships - remaining).round()),
      );
      return;
    }

    _updateBase(baseId, base.copyWith(shield: 0, ships: 0));
  }

  BattleBase? _baseAtCell(int x, int y) {
    for (final b in _bases) {
      if (b.x == x && b.y == y) return b;
    }
    return null;
  }

  (int, int) _cellOnEdge(int edge, Random rng) {
    switch (edge) {
      case 0:
        return (rng.nextInt(gridCols) + 1, 1);
      case 1:
        return (gridCols, rng.nextInt(gridRows) + 1);
      case 2:
        return (rng.nextInt(gridCols) + 1, gridRows);
      default:
        return (1, rng.nextInt(gridRows) + 1);
    }
  }

  void _advanceFleets() {
    final arrived = <BattleFleet>[];

    for (var i = 0; i < _fleets.length; i++) {
      final fleet = _fleets[i];
      final nextProgress = fleet.progress + _fleetProgressPerTick;
      if (nextProgress >= 1) {
        arrived.add(fleet);
      } else {
        _fleets[i] = fleet.copyWith(progress: nextProgress);
      }
    }

    for (final fleet in arrived) {
      _fleets.remove(fleet);
      _resolveFleetArrival(
        attackerSide: fleet.side,
        toId: fleet.toBaseId,
        fleetSize: fleet.ships,
      );
    }
  }

  BattleOutcome? outcome() {
    var player = 0;
    var enemy = 0;
    for (final b in _bases) {
      if (b.side == BattleSide.player) player++;
      if (b.side == BattleSide.enemy) enemy++;
    }
    if (player == 0) return BattleOutcome.playerLose;
    if (enemy == 0) return BattleOutcome.playerWin;
    return null;
  }

  void _resolveFleetArrival({
    required BattleSide attackerSide,
    required int toId,
    required int fleetSize,
  }) {
    final target = _base(toId);
    if (target == null) return;

    if (target.side == attackerSide) {
      _updateBase(
        toId,
        target.copyWith(
          ships: (target.ships + fleetSize).clamp(0, target.maxShips),
        ),
      );
      return;
    }

    final attackPower = attackerSide == BattleSide.player
        ? bonuses.attackPower
        : 1.0;
    var remaining = fleetSize * attackPower;
    var shield = target.shield;
    if (target.side == BattleSide.player) {
      shield *= bonuses.shieldDefense;
    }

    if (shield > 0) {
      if (shield >= remaining) {
        _updateBase(toId, target.copyWith(shield: shield - remaining));
        return;
      }
      remaining -= shield;
      shield = 0;
    }

    final garrison = target.ships.toDouble();
    if (garrison > remaining) {
      _updateBase(
        toId,
        target.copyWith(shield: 0, ships: (garrison - remaining).round()),
      );
      return;
    }

    final capturedShips =
        (remaining - garrison).round().clamp(1, target.maxShips);
    _updateBase(
      toId,
      target.copyWith(
        side: attackerSide,
        shield: 0,
        ships: capturedShips,
        resources: attackerSide == BattleSide.player ? 80 : 0,
        speedBuild: target.speedBuild > 0 ? target.speedBuild : 0.1,
        speedResources:
            target.speedResources > 0 ? target.speedResources : 0.1,
      ),
    );
  }

  void _updateBase(int id, BattleBase updated) {
    final index = _bases.indexWhere((b) => b.id == id);
    if (index >= 0) _bases[index] = updated;
  }

  BattleBase? _base(int id) {
    for (final b in _bases) {
      if (b.id == id) return b;
    }
    return null;
  }

  static BattleSide _sideForRole(PlacementRole role) {
    switch (role) {
      case PlacementRole.playerMain:
        return BattleSide.player;
      case PlacementRole.enemyMain:
        return BattleSide.enemy;
      case PlacementRole.neutral:
        return BattleSide.neutral;
    }
  }

  static _BaseStats _parseStats(String? statsJson) {
    if (statsJson == null || statsJson.isEmpty) {
      return const _BaseStats(
        ships: 30,
        shield: 0,
        maxShips: 120,
        speedBuild: 0.1,
        speedResources: 0.1,
      );
    }
    try {
      final map = jsonDecode(statsJson) as Map<String, dynamic>;
      return _BaseStats(
        ships: map['ships'] as int? ?? map['inicialShips'] as int? ?? 50,
        shield: (map['shild'] as num?)?.toDouble() ?? 0,
        maxShips: map['maxShips'] as int? ?? 200,
        speedBuild: (map['speedBuild'] as num?)?.toDouble() ?? 0.1,
        speedResources: (map['speedResources'] as num?)?.toDouble() ?? 0.1,
      );
    } catch (_) {
      return const _BaseStats(
        ships: 40,
        shield: 10,
        maxShips: 150,
        speedBuild: 0.1,
        speedResources: 0.1,
      );
    }
  }
}

class _BaseStats {
  const _BaseStats({
    required this.ships,
    required this.shield,
    required this.maxShips,
    required this.speedBuild,
    required this.speedResources,
  });

  final int ships;
  final double shield;
  final int maxShips;
  final double speedBuild;
  final double speedResources;
}
