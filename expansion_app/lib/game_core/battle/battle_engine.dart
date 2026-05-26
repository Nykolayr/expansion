import 'dart:convert';

import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_layout.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/domain/enums/placement_role.dart';
import 'package:expansion/game_core/battle/battle_line_of_sight.dart';

enum BattleOutcome { playerWin, playerLose }

/// Правила боя (без Flutter). MVP: флот приходит и разрешается сразу.
class BattleEngine {
  BattleEngine({
    required this.sceneId,
    required List<BattleBase> bases,
    required this.gridRows,
    required this.gridCols,
  }) : _bases = List.of(bases);

  factory BattleEngine.fromLayout(BattleLayout layout) {
    var nextId = 0;
    final bases = <BattleBase>[];

    for (final placed in layout.placements) {
      final side = _sideForRole(placed.role);
      final stats = _parseStats(placed.statsJson);
      bases.add(
        BattleBase(
          id: nextId++,
          x: placed.position.x,
          y: placed.position.y,
          side: side,
          ships: stats.ships,
          shield: stats.shield,
          maxShips: stats.maxShips,
        ),
      );
    }

    return BattleEngine(
      sceneId: layout.sceneId,
      bases: bases,
      gridRows: layout.gridRows,
      gridCols: layout.gridCols,
    );
  }

  final int sceneId;
  final int gridRows;
  final int gridCols;
  final List<BattleBase> _bases;
  int _tick = 0;
  int _growthCounter = 0;

  static const int _growthIntervalTicks = 12;

  BattleSnapshot snapshot() => BattleSnapshot(
        sceneId: sceneId,
        tick: _tick,
        bases: List.unmodifiable(_bases),
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
    _resolveFleetArrival(attackerSide: from.side, toId: toId, fleetSize: fleetSize);
    return true;
  }

  void tick() {
    _tick++;
    _growthCounter++;
    if (_growthCounter < _growthIntervalTicks) return;
    _growthCounter = 0;

    for (var i = 0; i < _bases.length; i++) {
      final b = _bases[i];
      if (b.ships >= b.maxShips) continue;
      _bases[i] = b.copyWith(ships: (b.ships + 1).clamp(0, b.maxShips));
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
    final target = _base(toId)!;

    if (target.side == attackerSide) {
      _updateBase(
        toId,
        target.copyWith(ships: (target.ships + fleetSize).clamp(0, target.maxShips)),
      );
      return;
    }

    var remaining = fleetSize.toDouble();
    var shield = target.shield;
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

    _updateBase(
      toId,
      target.copyWith(
        side: attackerSide,
        shield: 0,
        ships: (remaining - garrison).round().clamp(1, target.maxShips),
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
      return const _BaseStats(ships: 30, shield: 0, maxShips: 120);
    }
    try {
      final map = jsonDecode(statsJson) as Map<String, dynamic>;
      return _BaseStats(
        ships: map['ships'] as int? ?? map['inicialShips'] as int? ?? 50,
        shield: (map['shild'] as num?)?.toDouble() ?? 0,
        maxShips: map['maxShips'] as int? ?? 200,
      );
    } catch (_) {
      return const _BaseStats(ships: 40, shield: 10, maxShips: 150);
    }
  }
}

class _BaseStats {
  const _BaseStats({
    required this.ships,
    required this.shield,
    required this.maxShips,
  });

  final int ships;
  final double shield;
  final int maxShips;
}
