import 'dart:convert';
import 'dart:math';

import 'package:expansion/domain/entities/battle_asteroid.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_explosion.dart';
import 'package:expansion/domain/entities/battle_fleet.dart';
import 'package:expansion/domain/entities/battle_layout.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/domain/entities/meta_battle_bonuses.dart';
import 'package:expansion/domain/entities/placed_base.dart';
import 'package:expansion/domain/enums/battle_hazard_kind.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/domain/enums/placement_role.dart';
import 'package:expansion/domain/enums/tactical_upgrade_type.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/game_core/battle/battle_difficulty_config.dart';
import 'package:expansion/game_core/battle/battle_fleet_rules.dart';
import 'package:expansion/game_core/battle/battle_line_of_sight.dart';
import 'package:expansion/game_core/battle/battle_mission_hazards.dart';
import 'package:expansion/game_core/battle/battle_pacing.dart';
import 'package:expansion/game_core/battle/battle_tactical_balance.dart';
import 'package:expansion/game_core/battle/neutral_base_balance.dart';
import 'package:expansion/game_core/battle/tactical_upgrade_result.dart';
import 'package:expansion/domain/enums/neutral_base_kind.dart';
import 'package:expansion/domain/enums/neutral_base_variant.dart';

enum BattleOutcome { playerWin, playerLose }

/// Правила боя (без Flutter). Флоты летят по тикам, затем разрешается бой.
class BattleEngine {
  BattleEngine({
    required this.sceneId,
    required List<BattleBase> bases,
    required this.gridRows,
    required this.gridCols,
    this.bonuses = MetaBattleBonuses.none,
    this.difficulty = GameDifficulty.average,
  })  : _bases = List.of(bases),
        _fleets = [],
        _asteroids = [],
        _explosions = [],
        _mission1TutorialCaptureBaseId = sceneId == 1
            ? _computeMission1TutorialCaptureBaseId(bases)
            : null;

  factory BattleEngine.fromLayout(
    BattleLayout layout, {
    MetaBattleBonuses bonuses = MetaBattleBonuses.none,
    GameDifficulty difficulty = GameDifficulty.average,
  }) {
    var nextId = 0;
    final bases = <BattleBase>[];

    for (final placed in layout.placements) {
      final side = _sideForRole(placed.role);
      final stats = _resolvePlacementStats(placed);
      var ships = stats.ships;
      if (side == BattleSide.player &&
          placed.role == PlacementRole.playerMain &&
          bonuses.beginShipsBonus > 0) {
        ships += bonuses.beginShipsBonus;
      }

      var resources = 0.0;
      if (side == BattleSide.player && placed.role == PlacementRole.playerMain) {
        resources = 120;
      } else if (side == BattleSide.enemy &&
          placed.role == PlacementRole.enemyMain) {
        resources = 80;
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
          neutralVariant: stats.variant,
          isCommandBase: placed.role == PlacementRole.playerMain ||
              placed.role == PlacementRole.enemyMain,
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
      difficulty: difficulty,
    );
  }

  final int sceneId;
  final int gridRows;
  final int gridCols;
  final MetaBattleBonuses bonuses;
  final GameDifficulty difficulty;
  final List<BattleBase> _bases;
  final List<BattleFleet> _fleets;
  final List<BattleAsteroid> _asteroids;
  final List<BattleExplosion> _explosions;
  final int? _mission1TutorialCaptureBaseId;
  int? _tutorialCaptureBonusBaseId;
  bool _tutorialCaptureBonusGranted = false;
  int _tick = 0;
  int _nextFleetId = 1;
  int _nextAsteroidId = 1;
  int _nextExplosionId = 1;
  int _asteroidSpawnCounter = 0;
  int _debrisSpawnCounter = 0;
  int _cometSpawnCounter = 0;
  int _pulseSpawnCounter = 0;
  int _droneReinforcementCounter = 0;
  int _mineSpawnCounter = 0;
  int _solarWindSpawnCounter = 0;
  int _solarWindRowIndex = 0;
  int _wormholeSpawnCounter = 0;
  Random? _random;

  static const double _asteroidProgressPerTick =
      BattlePacing.asteroidProgressPerTick;
  static const double _debrisProgressPerTick =
      BattlePacing.debrisProgressPerTick;
  static const double _cometProgressPerTick =
      BattlePacing.cometProgressPerTick;
  static const double _pulseProgressPerTick = BattlePacing.pulseProgressPerTick;
  static const double _solarWindProgressPerTick =
      BattlePacing.solarWindProgressPerTick;
  static const double _wormholeProgressPerTick =
      BattlePacing.wormholeProgressPerTick;

  int get _asteroidSpawnIntervalTicks =>
      BattleMissionHazards.asteroidSpawnIntervalTicks(sceneId);

  int get _debrisSpawnIntervalTicks =>
      BattleMissionHazards.debrisSpawnIntervalTicks(sceneId);

  void bindRandom(Random random) => _random = random;

  /// База туториала м1 (ближайшая нейтральная к «матке»).
  int? get mission1TutorialCaptureBaseId => _mission1TutorialCaptureBaseId;

  /// Цель свайпа в туториале — при захвате этой базы дать ресурсы на апгрейд.
  void setTutorialCaptureBonusBaseId(int? baseId) {
    _tutorialCaptureBonusBaseId = baseId;
  }

  static const double _baseFleetProgressPerTick =
      BattlePacing.baseFleetProgressPerGridCell;

  double _fleetProgressForSide(BattleSide side) {
    final diff = BattleDifficultyConfig.forDifficulty(difficulty);
    return switch (side) {
      BattleSide.player =>
        _baseFleetProgressPerTick * bonuses.fleetSpeed * diff.playerFleetSpeedMul,
      BattleSide.enemy =>
        _baseFleetProgressPerTick * diff.enemyFleetSpeedMul,
      BattleSide.neutral => _baseFleetProgressPerTick,
    };
  }

  /// Половина кораблей на базе (минимум 1).
  static int defaultSendCount(int shipsOnBase) => defaultFleetSendCount(shipsOnBase);

  static const double _resourceIncomePerTick =
      BattlePacing.resourceIncomePerTick;
  static const int _tacticalBaseCost = 80;

  BattleSnapshot snapshot() => BattleSnapshot(
        sceneId: sceneId,
        tick: _tick,
        bases: List.unmodifiable(_bases),
        fleets: List.unmodifiable(_fleets),
        asteroids: List.unmodifiable(_asteroids),
        explosions: List.unmodifiable(_explosions),
        gridRows: gridRows,
        gridCols: gridCols,
      );

  /// Клетка-препятствие на линии (для крестика в UI).
  (int x, int y)? lineOfSightBlocker(int fromId, int toId) {
    final from = _base(fromId);
    final to = _base(toId);
    if (from == null || to == null) return null;
    return BattleLineOfSight.blockerCell(snapshot(), from, to);
  }

  bool canSendFleet(int fromId, int toId, {BattleSide? requiredSide}) {
    final from = _base(fromId);
    final to = _base(toId);
    if (from == null || to == null) return false;
    if (requiredSide != null && from.side != requiredSide) return false;
    if (from.ships < 1) return false;
    return BattleLineOfSight.isClear(snapshot(), from, to);
  }

  bool sendFleet(
    int fromId,
    int toId, {
    BattleSide? requiredSide,
    int? shipCount,
  }) {
    if (!canSendFleet(fromId, toId, requiredSide: requiredSide)) {
      return false;
    }
    final from = _base(fromId)!;
    final fleetSize = shipCount ?? defaultSendCount(from.ships);
    if (fleetSize < 1 || fleetSize > from.ships) return false;
    _updateBase(fromId, from.copyWith(ships: from.ships - fleetSize));
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

  void tick({bool spawnAsteroids = true}) {
    _tick++;
    _advanceFleets();
    _advanceExplosions();
    _advanceAsteroids();
    _resolveAsteroidFleetCollisions();
    if (spawnAsteroids) {
      _maybeSpawnAsteroid();
      _maybeSpawnDebris();
      _maybeSpawnComet();
      _maybeSpawnPulse();
      _maybeSpawnMines();
      _maybeSpawnSolarWind();
      _maybeSpawnWormhole();
    }
    _economyTick();
  }

  void _advanceExplosions() {
    for (var i = 0; i < _explosions.length; i++) {
      _explosions[i] =
          _explosions[i].copyWith(ageTicks: _explosions[i].ageTicks + 1);
    }
    _explosions.removeWhere((e) => e.ageTicks >= BattleExplosion.maxAgeTicks);
  }

  void _spawnExplosion(double gridX, double gridY) {
    _explosions.add(
      BattleExplosion(
        id: _nextExplosionId++,
        gridX: gridX,
        gridY: gridY,
        ageTicks: 0,
      ),
    );
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
        // maxShips — порог автопостройки, не потолок вместимости.
        final diff = BattleDifficultyConfig.forDifficulty(difficulty);
        final growthMul = base.side == BattleSide.player
            ? bonuses.growthSpeed
            : diff.enemyGrowthSpeedMul;
        final threshold = BattleTacticalBalance.shipGrowthThresholdTicks(
          speedBuild: base.speedBuild,
          buildUpgradeLevel: base.buildUpgradeLevel,
          growthMul: growthMul,
        );
        var acc = base.growthAccumulator + 1;
        if (acc >= threshold) {
          base = base.copyWith(ships: base.ships + 1, growthAccumulator: 0);
        } else {
          base = base.copyWith(growthAccumulator: acc);
        }
      }

      _bases[i] = base;
    }

    if (BattleMissionHazards.droneEnabled(sceneId)) {
      _droneReinforcementCounter++;
      if (_droneReinforcementCounter >=
          BattleMissionHazards.droneReinforcementIntervalTicks(sceneId)) {
        _droneReinforcementCounter = 0;
        _applyDroneReinforcement();
      }
    }
  }

  void _applyDroneReinforcement() {
    final ships = BattleMissionHazards.droneReinforcementShips(sceneId);
    if (ships <= 0) return;

    for (var i = 0; i < _bases.length; i++) {
      final base = _bases[i];
      if (base.side != BattleSide.enemy || !base.isCommandBase) continue;
      _bases[i] = base.copyWith(ships: base.ships + ships);
      return;
    }
  }

  int tacticalUpgradeCost(BattleBase base, TacticalUpgradeType type) {
    if (base.isTacticalMaxed(type)) return 0;
    return _tacticalBaseCost * (1 << base.tacticalLevelFor(type));
  }

  /// Можно купить улучшение [type] на базе (игрок или враг).
  bool canAffordTacticalUpgrade(BattleBase base, TacticalUpgradeType type) {
    if (base.side == BattleSide.neutral) return false;
    if (base.isTacticalMaxed(type)) return false;
    return base.resources >= tacticalUpgradeCost(base, type);
  }

  /// Есть ресурсы на хотя бы одно тактическое улучшение (жёлтый ▲ на базе).
  bool hasAffordableTacticalUpgrade(BattleBase base) {
    if (base.side != BattleSide.player) return false;
    for (final type in TacticalUpgradeType.values) {
      if (canAffordTacticalUpgrade(base, type)) return true;
    }
    return false;
  }

  /// База игрока — панель статуса всегда доступна по тапу.
  bool canOpenTacticalStatus(BattleBase base) =>
      base.side == BattleSide.player;

  /// Текущее и следующее значение для UI улучшений.
  ({String current, String next, int cost, bool maxed}) tacticalPreview(
    BattleBase base,
    TacticalUpgradeType type,
  ) {
    final maxed = base.isTacticalMaxed(type);
    final cost = maxed ? 0 : tacticalUpgradeCost(base, type);
    return switch (type) {
      TacticalUpgradeType.shield => (
          current: '${base.shield.round()}',
          next: '${(base.shield + 20).round()}',
          cost: cost,
          maxed: maxed,
        ),
      TacticalUpgradeType.buildSpeed => (
          current: BattleTacticalBalance.formatBuildMultiplier(
            base.buildUpgradeLevel,
          ),
          next: BattleTacticalBalance.formatBuildMultiplier(
            base.buildUpgradeLevel + 1,
          ),
          cost: cost,
          maxed: maxed,
        ),
      TacticalUpgradeType.maxShips => (
          current: '${base.maxShips}',
          next: '${base.maxShips + 35}',
          cost: cost,
          maxed: maxed,
        ),
    };
  }

  TacticalUpgradeResult applyTacticalUpgrade(
    int baseId,
    TacticalUpgradeType type,
  ) {
    final base = _base(baseId);
    if (base == null) return TacticalUpgradeResult.invalidBase;
    if (base.side == BattleSide.neutral) {
      return TacticalUpgradeResult.invalidBase;
    }
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
          buildUpgradeLevel: base.buildUpgradeLevel + 1,
          growthAccumulator: 0,
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

  void _maybeSpawnDebris() {
    if (!BattleMissionHazards.debrisEnabled(sceneId)) return;
    final rng = _random;
    if (rng == null) return;
    _debrisSpawnCounter++;
    if (_debrisSpawnCounter < _debrisSpawnIntervalTicks) return;
    _debrisSpawnCounter = 0;

    final row = BattleMissionHazards.debrisCorridorRow;
    final leftToRight = rng.nextBool();
    final from = leftToRight ? (1, row) : (gridCols, row);
    final to = leftToRight ? (gridCols, row) : (1, row);
    final power = BattleMissionHazards.debrisDisplayPowerMin +
        rng.nextInt(
          BattleMissionHazards.debrisDisplayPowerMax -
              BattleMissionHazards.debrisDisplayPowerMin +
              1,
        );

    _asteroids.add(
      BattleAsteroid(
        id: _nextAsteroidId++,
        fromX: from.$1,
        fromY: from.$2,
        toX: to.$1,
        toY: to.$2,
        power: power,
        kind: BattleHazardKind.debris,
        visualIndex: 5,
      ),
    );
  }

  void _maybeSpawnAsteroid() {
    if (!BattleMissionHazards.asteroidsEnabled(sceneId)) return;
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
        kind: BattleHazardKind.asteroid,
        visualIndex: visualIndex,
      ),
    );
  }

  void _maybeSpawnComet() {
    if (!BattleMissionHazards.cometEnabled(sceneId)) return;
    final rng = _random;
    if (rng == null) return;
    _cometSpawnCounter++;
    if (_cometSpawnCounter < BattleMissionHazards.cometSpawnIntervalTicks(sceneId)) {
      return;
    }
    _cometSpawnCounter = 0;

    final col = BattleMissionHazards.cometCorridorColumn;
    final topToBottom = rng.nextBool();
    final from = topToBottom ? (col, 2) : (col, 6);
    final to = topToBottom ? (col, 6) : (col, 2);

    _asteroids.add(
      BattleAsteroid(
        id: _nextAsteroidId++,
        fromX: from.$1,
        fromY: from.$2,
        toX: to.$1,
        toY: to.$2,
        power: BattleMissionHazards.cometPower,
        kind: BattleHazardKind.comet,
        visualIndex: 1,
      ),
    );
  }

  void _maybeSpawnPulse() {
    if (!BattleMissionHazards.pulseEnabled(sceneId)) return;
    _pulseSpawnCounter++;
    if (_pulseSpawnCounter < BattleMissionHazards.pulseSpawnIntervalTicks(sceneId)) {
      return;
    }
    _pulseSpawnCounter = 0;

    final originX = BattleMissionHazards.pulseOriginX;
    final originY = BattleMissionHazards.pulseOriginY;
    final targets = <(int, int)>[
      (1, originY),
      (5, originY),
      (originX, 2),
      (originX, 6),
    ];

    for (final target in targets) {
      _asteroids.add(
        BattleAsteroid(
          id: _nextAsteroidId++,
          fromX: originX,
          fromY: originY,
          toX: target.$1,
          toY: target.$2,
          power: BattleMissionHazards.pulsePower,
          kind: BattleHazardKind.pulse,
          visualIndex: 1,
        ),
      );
    }
  }

  void _maybeSpawnMines() {
    if (!BattleMissionHazards.mineEnabled(sceneId)) return;
    final activeMines =
        _asteroids.where((a) => a.kind == BattleHazardKind.mine).length;
    if (activeMines >= BattleMissionHazards.mineCells.length) return;

    _mineSpawnCounter++;
    if (_mineSpawnCounter < BattleMissionHazards.mineRespawnIntervalTicks(sceneId)) {
      return;
    }
    _mineSpawnCounter = 0;

    for (final cell in BattleMissionHazards.mineCells) {
      final occupied = _asteroids.any(
        (a) =>
            a.kind == BattleHazardKind.mine &&
            a.fromX == cell.$1 &&
            a.fromY == cell.$2,
      );
      if (occupied) continue;

      _asteroids.add(
        BattleAsteroid(
          id: _nextAsteroidId++,
          fromX: cell.$1,
          fromY: cell.$2,
          toX: cell.$1,
          toY: cell.$2,
          power: BattleMissionHazards.minePower,
          kind: BattleHazardKind.mine,
          visualIndex: 1,
        ),
      );
    }
  }

  void _maybeSpawnSolarWind() {
    if (!BattleMissionHazards.solarWindEnabled(sceneId)) return;
    final rng = _random;
    if (rng == null) return;
    _solarWindSpawnCounter++;
    if (_solarWindSpawnCounter <
        BattleMissionHazards.solarWindSpawnIntervalTicks(sceneId)) {
      return;
    }
    _solarWindSpawnCounter = 0;

    final rows = BattleMissionHazards.solarWindRows;
    final row = rows[_solarWindRowIndex % rows.length];
    _solarWindRowIndex++;

    _asteroids.add(
      BattleAsteroid(
        id: _nextAsteroidId++,
        fromX: 1,
        fromY: row,
        toX: gridCols,
        toY: row,
        power: BattleMissionHazards.solarWindPower,
        kind: BattleHazardKind.solarWind,
        visualIndex: 1,
      ),
    );
  }

  void _maybeSpawnWormhole() {
    if (!BattleMissionHazards.wormholeEnabled(sceneId)) return;
    final rng = _random;
    if (rng == null) return;
    _wormholeSpawnCounter++;
    if (_wormholeSpawnCounter <
        BattleMissionHazards.wormholeSpawnIntervalTicks(sceneId)) {
      return;
    }
    _wormholeSpawnCounter = 0;

    if (rng.nextBool()) {
      _asteroids.add(
        BattleAsteroid(
          id: _nextAsteroidId++,
          fromX: 2,
          fromY: 6,
          toX: 4,
          toY: 2,
          power: BattleMissionHazards.wormholePower,
          kind: BattleHazardKind.wormhole,
          visualIndex: 1,
        ),
      );
    } else {
      _asteroids.add(
        BattleAsteroid(
          id: _nextAsteroidId++,
          fromX: 4,
          fromY: 6,
          toX: 2,
          toY: 2,
          power: BattleMissionHazards.wormholePower,
          kind: BattleHazardKind.wormhole,
          visualIndex: 1,
        ),
      );
    }
  }

  void _advanceAsteroids() {
    final removeIds = <int>{};

    for (var i = 0; i < _asteroids.length; i++) {
      final ast = _asteroids[i];
      if (ast.kind == BattleHazardKind.mine) {
        final cell = (ast.fromX, ast.fromY);
        final base = _baseAtCell(cell.$1, cell.$2);
        if (base != null) {
          _spawnExplosion(base.x.toDouble(), base.y.toDouble());
          _applyPowerHitToBase(base.id, ast.power);
          removeIds.add(ast.id);
        }
        continue;
      }

      final step = switch (ast.kind) {
        BattleHazardKind.debris => _debrisProgressPerTick,
        BattleHazardKind.comet => _cometProgressPerTick,
        BattleHazardKind.pulse => _pulseProgressPerTick,
        BattleHazardKind.solarWind => _solarWindProgressPerTick,
        BattleHazardKind.wormhole => _wormholeProgressPerTick,
        BattleHazardKind.asteroid => _asteroidProgressPerTick,
        BattleHazardKind.mine => 0,
      };
      final nextProgress = ast.progress + step;
      if (nextProgress >= 1) {
        removeIds.add(ast.id);
        continue;
      }

      final updated = ast.copyWith(progress: nextProgress);
      _asteroids[i] = updated;

      final cell = _asteroidCell(updated);
      final base = _baseAtCell(cell.$1, cell.$2);
      if (base != null) {
        _spawnExplosion(base.x.toDouble(), base.y.toDouble());
        if (updated.kind == BattleHazardKind.debris ||
            updated.kind == BattleHazardKind.solarWind) {
          _applyDebrisHitToBase(base.id);
        } else {
          _applyPowerHitToBase(base.id, updated.power);
          removeIds.add(updated.id);
        }
      }
    }

    if (removeIds.isNotEmpty) {
      _asteroids.removeWhere((a) => removeIds.contains(a.id));
    }
  }

  (int x, int y) _asteroidCell(BattleAsteroid ast) {
    final pos = _asteroidGridPosition(ast);
    return (pos.$1.round().clamp(1, gridCols), pos.$2.round().clamp(1, gridRows));
  }

  (double x, double y) _asteroidGridPosition(BattleAsteroid ast) {
    final t = ast.progress.clamp(0.0, 1.0);
    return (
      ast.fromX + (ast.toX - ast.fromX) * t,
      ast.fromY + (ast.toY - ast.fromY) * t,
    );
  }

  void _resolveAsteroidFleetCollisions() {
    const collideRadius = 0.38;
    final removeFleets = <int>{};
    final removeAsteroids = <int>{};
    final fleetUpdates = <int, BattleFleet>{};
    final asteroidUpdates = <int, BattleAsteroid>{};

    for (var ai = 0; ai < _asteroids.length; ai++) {
      var ast = asteroidUpdates[_asteroids[ai].id] ?? _asteroids[ai];
      if (removeAsteroids.contains(ast.id)) continue;

      final pa = _asteroidGridPosition(ast);

      for (final fleet in _fleets) {
        if (removeFleets.contains(fleet.id)) continue;

        final f = fleetUpdates[fleet.id] ?? fleet;
        final pf = _fleetGridPosition(f);
        final dx = pa.$1 - pf.$1;
        final dy = pa.$2 - pf.$2;
        if (dx * dx + dy * dy > collideRadius * collideRadius) continue;

        _spawnExplosion((pa.$1 + pf.$1) / 2, (pa.$2 + pf.$2) / 2);

        if (ast.kind == BattleHazardKind.debris ||
            ast.kind == BattleHazardKind.solarWind) {
          final lost = _debrisShipsDestroyed(f.ships);
          final remaining = f.ships - lost;
          if (remaining <= 0) {
            removeFleets.add(fleet.id);
          } else {
            fleetUpdates[fleet.id] = f.copyWith(ships: remaining);
          }
          if (ast.kind == BattleHazardKind.debris) {
            break;
          }
          removeAsteroids.add(ast.id);
          break;
        }

        if (ast.kind == BattleHazardKind.mine) {
          final lost = f.ships.clamp(0, ast.power);
          final remaining = f.ships - lost;
          if (remaining <= 0) {
            removeFleets.add(fleet.id);
          } else {
            fleetUpdates[fleet.id] = f.copyWith(ships: remaining);
          }
          removeAsteroids.add(ast.id);
          break;
        }

        final power = ast.power;
        final ships = f.ships;

        if (ships > power) {
          fleetUpdates[fleet.id] = f.copyWith(ships: ships - power);
          removeAsteroids.add(ast.id);
        } else {
          removeFleets.add(fleet.id);
          final remainingPower = power - ships;
          if (remainingPower <= 0) {
            removeAsteroids.add(ast.id);
          } else {
            ast = ast.copyWith(power: remainingPower);
            asteroidUpdates[ast.id] = ast;
          }
        }
        break;
      }
    }

    if (removeFleets.isEmpty &&
        removeAsteroids.isEmpty &&
        fleetUpdates.isEmpty &&
        asteroidUpdates.isEmpty) {
      return;
    }

    _fleets.removeWhere((f) => removeFleets.contains(f.id));
    for (var i = 0; i < _fleets.length; i++) {
      final updated = fleetUpdates[_fleets[i].id];
      if (updated != null) _fleets[i] = updated;
    }

    _asteroids.removeWhere((a) => removeAsteroids.contains(a.id));
    for (var i = 0; i < _asteroids.length; i++) {
      final updated = asteroidUpdates[_asteroids[i].id];
      if (updated != null) _asteroids[i] = updated;
    }
  }

  int _debrisShipsDestroyed(int ships) {
    if (ships <= 0) return 0;
    final lost =
        (ships * BattleMissionHazards.debrisShipLossFraction).round();
    return lost.clamp(1, ships);
  }

  void _applyDebrisHitToBase(int baseId) {
    final base = _base(baseId);
    if (base == null) return;

    final lost = _debrisShipsDestroyed(base.ships);
    _updateBase(
      baseId,
      base.copyWith(
        shield: 0,
        ships: base.ships - lost,
      ),
    );
  }

  void _applyPowerHitToBase(int baseId, int power) {
    _applyAsteroidHit(baseId, power);
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
      final distance = _fleetTravelDistance(fleet);
      final step = _fleetProgressForSide(fleet.side) / distance;
      final nextProgress = fleet.progress + step;
      if (nextProgress >= 1) {
        arrived.add(fleet);
      } else {
        _fleets[i] = fleet.copyWith(progress: nextProgress);
      }
    }

    _resolveMidairFleetClashes();

    for (final fleet in arrived) {
      _fleets.remove(fleet);
      _resolveFleetArrival(
        attackerSide: fleet.side,
        toId: fleet.toBaseId,
        fleetSize: fleet.ships,
      );
    }
  }

  double _fleetTravelDistance(BattleFleet fleet) {
    final from = _base(fleet.fromBaseId);
    final to = _base(fleet.toBaseId);
    if (from == null || to == null) return 1;
    final dx = (to.x - from.x).toDouble();
    final dy = (to.y - from.y).toDouble();
    return sqrt(dx * dx + dy * dy).clamp(1.0, double.infinity);
  }

  (double x, double y) _fleetGridPosition(BattleFleet fleet) {
    final from = _base(fleet.fromBaseId);
    final to = _base(fleet.toBaseId);
    if (from == null || to == null) return (0, 0);
    final t = fleet.progress.clamp(0.0, 1.0);
    return (
      from.x + (to.x - from.x) * t,
      from.y + (to.y - from.y) * t,
    );
  }

  void _resolveMidairFleetClashes() {
    const collideRadius = 0.38;
    final removeIds = <int>{};
    final updates = <int, BattleFleet>{};

    for (var i = 0; i < _fleets.length; i++) {
      final a = _fleets[i];
      if (removeIds.contains(a.id)) continue;

      for (var j = i + 1; j < _fleets.length; j++) {
        final b = _fleets[j];
        if (removeIds.contains(b.id)) continue;
        if (a.side == b.side) continue;

        final pa = _fleetGridPosition(a);
        final pb = _fleetGridPosition(b);
        final dx = pa.$1 - pb.$1;
        final dy = pa.$2 - pb.$2;
        if (dx * dx + dy * dy > collideRadius * collideRadius) continue;

        _spawnExplosion((pa.$1 + pb.$1) / 2, (pa.$2 + pb.$2) / 2);

        final aShips = updates[a.id]?.ships ?? a.ships;
        final bShips = updates[b.id]?.ships ?? b.ships;

        if (aShips > bShips) {
          removeIds.add(b.id);
          updates[a.id] = (updates[a.id] ?? a).copyWith(ships: aShips - bShips);
        } else if (bShips > aShips) {
          removeIds.add(a.id);
          updates[b.id] = (updates[b.id] ?? b).copyWith(ships: bShips - aShips);
        } else {
          removeIds.add(a.id);
          removeIds.add(b.id);
        }
      }
    }

    if (removeIds.isEmpty && updates.isEmpty) return;

    _fleets.removeWhere((f) => removeIds.contains(f.id));
    for (var i = 0; i < _fleets.length; i++) {
      final updated = updates[_fleets[i].id];
      if (updated != null) {
        _fleets[i] = updated;
      }
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
          ships: target.ships + fleetSize,
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

    final capturedShips = (remaining - garrison).round().clamp(1, 99999);
    _updateBase(
      toId,
      target.copyWith(
        side: attackerSide,
        isCommandBase: false,
        shield: 0,
        ships: capturedShips,
        resources: _resourcesOnCapture(attackerSide, toId),
        speedBuild: target.speedBuild > 0 ? target.speedBuild : 0.1,
        speedResources:
            target.speedResources > 0 ? target.speedResources : 0.1,
      ),
    );
  }

  double _resourcesOnCapture(BattleSide attackerSide, int baseId) {
    if (attackerSide != BattleSide.player || sceneId != 1) return 0;
    if (_tutorialCaptureBonusGranted) return 0;

    final bonusBaseId =
        _tutorialCaptureBonusBaseId ?? _mission1TutorialCaptureBaseId;
    if (bonusBaseId == null || baseId != bonusBaseId) return 0;

    _tutorialCaptureBonusGranted = true;
    return _tacticalBaseCost.toDouble();
  }

  static int? _computeMission1TutorialCaptureBaseId(List<BattleBase> bases) {
    BattleBase? from;
    for (final base in bases) {
      if (base.side == BattleSide.player && base.isCommandBase) {
        from = base;
        break;
      }
    }
    if (from == null) {
      for (final base in bases) {
        if (base.side == BattleSide.player) {
          from = base;
          break;
        }
      }
    }
    if (from == null) return null;

    BattleBase? best;
    var bestDist = double.infinity;
    for (final base in bases) {
      if (base.side != BattleSide.neutral) continue;
      final dx = (base.x - from.x).toDouble();
      final dy = (base.y - from.y).toDouble();
      final dist = dx * dx + dy * dy;
      if (dist < bestDist) {
        bestDist = dist;
        best = base;
      }
    }
    return best?.id;
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

  static _BaseStats _resolvePlacementStats(PlacedBase placed) {
    if (placed.role == PlacementRole.neutral) {
      if (placed.statsJson != null && placed.statsJson!.isNotEmpty) {
        return _parseStats(placed.statsJson);
      }
      final kind = placed.neutralKind ?? NeutralBaseKind.smallBase;
      final profile = NeutralBaseBalance.profileFor(kind: kind);
      return _BaseStats(
        ships: profile.ships,
        shield: profile.shield,
        maxShips: profile.maxShips,
        speedBuild: profile.speedBuild,
        speedResources: profile.speedResources,
      );
    }
    return _parseStats(placed.statsJson);
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
      if (map.containsKey('neutralKind')) {
        final profile = NeutralBaseBalance.fromJsonMap(map);
        return _BaseStats(
          ships: profile.ships,
          shield: profile.shield,
          maxShips: profile.maxShips,
          speedBuild: profile.speedBuild,
          speedResources: profile.speedResources,
          variant: NeutralBaseVariant.fromLegacy(map['variant'] as String?),
        );
      }
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

  /// Тестовый флот в полёте (середина пути).
  void debugPlaceFleetForTest({
    required int fromBaseId,
    required int toBaseId,
    required int ships,
    double progress = 0.5,
    BattleSide side = BattleSide.player,
  }) {
    _fleets.add(
      BattleFleet(
        id: _nextFleetId++,
        fromBaseId: fromBaseId,
        toBaseId: toBaseId,
        ships: ships,
        side: side,
        progress: progress,
      ),
    );
  }

  /// Тестовый астероид в фиксированной клетке сетки.
  void debugPlaceAsteroidForTest({
    required int gridX,
    required int gridY,
    required int power,
  }) {
    _asteroids.add(
      BattleAsteroid(
        id: _nextAsteroidId++,
        fromX: gridX,
        fromY: gridY,
        toX: gridX,
        toY: gridY,
        power: power,
        kind: BattleHazardKind.asteroid,
      ),
    );
  }

  /// Тестовый обломок в коридоре м5.
  void debugPlaceDebrisForTest({
    required int power,
    double progress = 0.5,
    bool leftToRight = true,
  }) {
    final row = BattleMissionHazards.debrisCorridorRow;
    _asteroids.add(
      BattleAsteroid(
        id: _nextAsteroidId++,
        fromX: leftToRight ? 1 : gridCols,
        fromY: row,
        toX: leftToRight ? gridCols : 1,
        toY: row,
        power: power,
        kind: BattleHazardKind.debris,
        visualIndex: 5,
        progress: progress,
      ),
    );
  }
}

class _BaseStats {
  const _BaseStats({
    required this.ships,
    required this.shield,
    required this.maxShips,
    required this.speedBuild,
    required this.speedResources,
    this.variant,
  });

  final int ships;
  final double shield;
  final int maxShips;
  final double speedBuild;
  final double speedResources;
  final NeutralBaseVariant? variant;
}
