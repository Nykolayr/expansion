import 'dart:math';

import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/game_core/ai/battle_intent.dart';
import 'package:expansion/game_core/ai/enemy_personality.dart';
import 'package:expansion/game_core/battle/battle_line_of_sight.dart';

/// «Мозг» чужих: правила + случайность, без UI.
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

    final enemyBases = snapshot.enemyBases.where((b) => b.ships > 1).toList();
    if (enemyBases.isEmpty) return const [WaitIntent()];

    final neutrals = snapshot.neutralBases.toList();
    final players = snapshot.playerBases.toList();

    final targets = <BattleBase>[];
    if (neutrals.isNotEmpty &&
        random.nextDouble() < personality.attackNeutralBias) {
      targets.addAll(neutrals);
    } else {
      targets.addAll(players);
      if (targets.isEmpty && neutrals.isNotEmpty) {
        targets.addAll(neutrals);
      }
    }

    if (targets.isEmpty) return const [WaitIntent()];

    final moves = <_Move>[];
    for (final from in enemyBases) {
      for (final to in targets) {
        if (!BattleLineOfSight.isClear(snapshot, from, to)) continue;
        final support = _collectAttackers(snapshot, enemyBases, from, to, random);
        if (support.isEmpty) continue;
        final force = support.fold<int>(0, (sum, b) => sum + b.power);
        moves.add(_Move(support, to, force));
      }
    }

    if (moves.isEmpty) return const [WaitIntent()];

    moves.sort((a, b) => a.force.compareTo(b.force));

    final pickSuboptimal = random.nextDouble() < personality.suboptimalChoiceChance;
    final chosen = pickSuboptimal
        ? moves[random.nextInt(moves.length)]
        : moves.last;

    final intents = <BattleIntent>[];
    for (final from in chosen.sources) {
      intents.add(SendFleetIntent(fromBaseId: from.id, toBaseId: chosen.target.id));
    }
    return intents.isEmpty ? const [WaitIntent()] : intents;
  }

  List<BattleBase> _collectAttackers(
    BattleSnapshot snapshot,
    List<BattleBase> enemyBases,
    BattleBase primary,
    BattleBase target,
    Random random,
  ) {
    final attackers = <BattleBase>[primary];
    var force = primary.power;
    final need = target.power + 5;

    final others = List<BattleBase>.from(enemyBases);
    _shuffle(others, random);
    for (final candidate in others) {
      if (candidate.id == primary.id) continue;
      if (!BattleLineOfSight.isClear(snapshot, candidate, target)) continue;
      attackers.add(candidate);
      force += candidate.power;
      if (force > need) break;
    }

    return force > need ? attackers : [];
  }

  void _shuffle(List<BattleBase> list, Random random) {
    for (var i = list.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
  }
}

class _Move {
  _Move(this.sources, this.target, this.force);

  final List<BattleBase> sources;
  final BattleBase target;
  final int force;
}
