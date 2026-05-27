import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/battle_asteroid.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_explosion.dart';
import 'package:expansion/domain/entities/battle_fleet.dart';
import 'package:expansion/domain/enums/battle_side.dart';

/// Снимок поля для UI и AI (иммутабельный после каждого хода).
class BattleSnapshot extends Equatable {
  const BattleSnapshot({
    required this.sceneId,
    required this.tick,
    required this.bases,
    required this.fleets,
    this.asteroids = const [],
    this.explosions = const [],
    required this.gridRows,
    required this.gridCols,
  });

  final int sceneId;
  final int tick;
  final List<BattleBase> bases;
  final List<BattleFleet> fleets;
  final List<BattleAsteroid> asteroids;
  final List<BattleExplosion> explosions;
  final int gridRows;
  final int gridCols;

  bool get hasActiveProjectiles =>
      fleets.isNotEmpty || asteroids.isNotEmpty;

  Iterable<BattleBase> get playerBases =>
      bases.where((b) => b.side == BattleSide.player);

  Iterable<BattleBase> get enemyBases =>
      bases.where((b) => b.side == BattleSide.enemy);

  Iterable<BattleBase> get neutralBases =>
      bases.where((b) => b.side == BattleSide.neutral);

  BattleBase? baseAt(int x, int y) {
    for (final base in bases) {
      if (base.x == x && base.y == y) return base;
    }
    return null;
  }

  BattleBase? baseById(int id) {
    for (final base in bases) {
      if (base.id == id) return base;
    }
    return null;
  }

  @override
  List<Object?> get props =>
      [sceneId, tick, bases, fleets, asteroids, explosions, gridRows, gridCols];
}
