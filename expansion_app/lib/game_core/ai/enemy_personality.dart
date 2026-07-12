import 'package:expansion/domain/enums/game_difficulty.dart';

/// Параметры «характера» чужих для RNG-решений.
class EnemyPersonality {
  const EnemyPersonality({
    required this.skipTurnChance,
    required this.suboptimalChoiceChance,
    required this.attackNeutralBias,
    required this.minAttackMargin,
    required this.reserveFraction,
    required this.minReserveShips,
  });

  factory EnemyPersonality.forDifficulty(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return const EnemyPersonality(
          skipTurnChance: 0.08,
          suboptimalChoiceChance: 0.16,
          attackNeutralBias: 0.55,
          minAttackMargin: 4,
          reserveFraction: 0.28,
          minReserveShips: 3,
        );
      case GameDifficulty.average:
        return const EnemyPersonality(
          skipTurnChance: 0.04,
          suboptimalChoiceChance: 0.08,
          attackNeutralBias: 0.45,
          minAttackMargin: 3,
          reserveFraction: 0.22,
          minReserveShips: 2,
        );
      case GameDifficulty.difficult:
        return const EnemyPersonality(
          skipTurnChance: 0.02,
          suboptimalChoiceChance: 0.04,
          attackNeutralBias: 0.38,
          minAttackMargin: 2,
          reserveFraction: 0.18,
          minReserveShips: 2,
        );
    }
  }

  final double skipTurnChance;
  final double suboptimalChoiceChance;
  final double attackNeutralBias;

  /// Запас силы цели: атакуем только если отправляемых кораблей хватает с запасом.
  final int minAttackMargin;

  /// Доля кораблей, которую AI старается держать на базе.
  final double reserveFraction;
  final int minReserveShips;
}
