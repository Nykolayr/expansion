import 'dart:math';

import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/enums/tactical_upgrade_type.dart';
import 'package:expansion/game_core/ai/enemy_personality.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';

/// Выбор тактического апгрейда для чужих (до отправки флота).
class EnemyUpgradeAdvisor {
  const EnemyUpgradeAdvisor();

  /// Не больше одного апгрейда за ход AI.
  ({int baseId, TacticalUpgradeType type})? pick({
    required BattleEngine engine,
    required BattleSnapshot snapshot,
    required EnemyPersonality personality,
    required GameDifficulty difficulty,
    required Random random,
  }) {
    if (_skipUpgradeRoll(difficulty, random)) return null;

    final candidates = <_ScoredUpgrade>[];
    for (final base in snapshot.enemyBases) {
      for (final type in TacticalUpgradeType.values) {
        if (!engine.canAffordTacticalUpgrade(base, type)) continue;
        final score = _score(base, type, snapshot, personality);
        candidates.add(_ScoredUpgrade(baseId: base.id, type: type, score: score));
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) => a.score.compareTo(b.score));

    final poolSize = switch (difficulty) {
      GameDifficulty.easy => 4,
      GameDifficulty.average => 3,
      GameDifficulty.difficult => 2,
    };
    final pool = candidates.length <= poolSize
        ? candidates
        : candidates.sublist(candidates.length - poolSize);

    final pickSuboptimal =
        random.nextDouble() < personality.suboptimalChoiceChance;
    final chosen = pickSuboptimal
        ? pool[random.nextInt(pool.length)]
        : pool.last;

    return (baseId: chosen.baseId, type: chosen.type);
  }

  bool _skipUpgradeRoll(GameDifficulty difficulty, Random random) {
    final chance = switch (difficulty) {
      GameDifficulty.easy => 0.38,
      GameDifficulty.average => 0.14,
      GameDifficulty.difficult => 0.04,
    };
    return random.nextDouble() < chance;
  }

  double _score(
    BattleBase base,
    TacticalUpgradeType type,
    BattleSnapshot snapshot,
    EnemyPersonality personality,
  ) {
    final nearestPlayer = _nearestPlayerDistance(base, snapshot);
    final fill = base.maxShips > 0 ? base.ships / base.maxShips : 0.0;

    var score = 0.0;

    switch (type) {
      case TacticalUpgradeType.shield:
        if (base.isCommandBase) score += 7;
        if (nearestPlayer <= 2.5) score += 5;
        if (base.shield < 50) score += 3;
        score -= base.shieldUpgradeLevel * 0.6;
      case TacticalUpgradeType.buildSpeed:
        if (fill < 0.6) score += 6;
        if (!base.isCommandBase) score += 1.5;
        if (base.ships < 30) score += 2;
        score -= base.buildUpgradeLevel * 0.5;
      case TacticalUpgradeType.maxShips:
        if (fill >= 0.7) score += 7;
        if (base.ships >= base.maxShips - 8) score += 4;
        score -= base.maxShipsUpgradeLevel * 0.6;
    }

    score += (base.resources / 160).clamp(0.0, 2.5);
    score -= personality.minAttackMargin * 0.05;
    return score;
  }

  double _nearestPlayerDistance(BattleBase base, BattleSnapshot snapshot) {
    var best = double.infinity;
    for (final player in snapshot.playerBases) {
      final dx = (player.x - base.x).toDouble();
      final dy = (player.y - base.y).toDouble();
      final dist = sqrt(dx * dx + dy * dy);
      if (dist < best) best = dist;
    }
    return best;
  }
}

class _ScoredUpgrade {
  const _ScoredUpgrade({
    required this.baseId,
    required this.type,
    required this.score,
  });

  final int baseId;
  final TacticalUpgradeType type;
  final double score;
}
