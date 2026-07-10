import 'dart:math';

import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/game_core/ai/battle_intent.dart';
import 'package:expansion/game_core/ai/enemy_personality.dart';
import 'package:expansion/game_core/battle/battle_fleet_rules.dart';
import 'package:expansion/game_core/battle/battle_line_of_sight.dart';

/// «Мозг» чужих: один осмысленный ход за тик, без массового слива всех баз.
class EnemyCommander {
  const EnemyCommander();

  List<BattleIntent> decide({
    required BattleSnapshot snapshot,
    required EnemyPersonality personality,
    required Random random,
  }) {
    if (random.nextDouble() < personality.skipTurnChance) {
      return const [WaitIntent()];
    }

    final enemyBases = snapshot.enemyBases
        .where((b) => _shipsToSend(b, personality) >= 2)
        .toList();
    if (enemyBases.isEmpty) return const [WaitIntent()];

    final targets = _pickTargetPool(snapshot, personality, random);
    if (targets.isEmpty) return const [WaitIntent()];

    final scored = <_ScoredAttack>[];
    for (final from in enemyBases) {
      final sendCount = _shipsToSend(from, personality);
      for (final to in targets) {
        if (!BattleLineOfSight.isClear(snapshot, from, to)) continue;

        final margin = sendCount - _defenseNeed(to, personality);
        if (margin < 0) continue;

        var score = margin.toDouble();
        if (to.side == BattleSide.player) {
          score += 4;
        } else if (to.side == BattleSide.neutral) {
          score += 1.5;
        }
        if (from.isCommandBase) score -= 3;
        if (from.ships > from.maxShips * 0.65) score += 2;
        score += random.nextDouble() * 1.5;

        scored.add(
          _ScoredAttack(
            from: from,
            to: to,
            ships: sendCount,
            score: score,
          ),
        );
      }
    }

    if (scored.isEmpty) {
      return const [WaitIntent()];
    }

    scored.sort((a, b) => a.score.compareTo(b.score));

    final pickWeak =
        random.nextDouble() < personality.suboptimalChoiceChance;
    final chosen =
        pickWeak ? scored[random.nextInt(scored.length)] : scored.last;

    return [
      SendFleetIntent(
        fromBaseId: chosen.from.id,
        toBaseId: chosen.to.id,
        shipCount: chosen.ships,
      ),
    ];
  }

  List<BattleBase> _pickTargetPool(
    BattleSnapshot snapshot,
    EnemyPersonality personality,
    Random random,
  ) {
    final players = snapshot.playerBases.toList();
    final neutrals = snapshot.neutralBases.toList();

    if (neutrals.isNotEmpty &&
        random.nextDouble() < personality.attackNeutralBias) {
      return neutrals;
    }
    if (players.isNotEmpty) return players;
    return neutrals;
  }

  int _defenseNeed(BattleBase target, EnemyPersonality personality) =>
      target.power + personality.minAttackMargin;

  /// Сколько кораблей можно отправить, оставив резерв на накопление.
  int _shipsToSend(BattleBase base, EnemyPersonality personality) {
    final reserve = (base.maxShips * personality.reserveFraction)
        .round()
        .clamp(personality.minReserveShips, 14);
    final available = base.ships - reserve;
    if (available < 2) return 0;
    return defaultFleetSendCount(available);
  }
}

class _ScoredAttack {
  _ScoredAttack({
    required this.from,
    required this.to,
    required this.ships,
    required this.score,
  });

  final BattleBase from;
  final BattleBase to;
  final int ships;
  final double score;
}
