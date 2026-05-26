import 'package:expansion/domain/enums/game_difficulty.dart';

/// Параметры «характера» чужих для RNG-решений.
class EnemyPersonality {
  const EnemyPersonality({
    required this.skipTurnChance,
    required this.suboptimalChoiceChance,
    required this.attackNeutralBias,
  });

  factory EnemyPersonality.forDifficulty(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return const EnemyPersonality(
          skipTurnChance: 0.12,
          suboptimalChoiceChance: 0.35,
          attackNeutralBias: 0.7,
        );
      case GameDifficulty.average:
        return const EnemyPersonality(
          skipTurnChance: 0.05,
          suboptimalChoiceChance: 0.18,
          attackNeutralBias: 0.55,
        );
      case GameDifficulty.difficult:
        return const EnemyPersonality(
          skipTurnChance: 0.02,
          suboptimalChoiceChance: 0.08,
          attackNeutralBias: 0.4,
        );
    }
  }

  /// Иногда AI «думает» и пропускает ход.
  final double skipTurnChance;

  /// Выбрать не лучшую, а случайную допустимую цель.
  final double suboptimalChoiceChance;

  /// Вероятность сначала давить нейтралов, если они есть.
  final double attackNeutralBias;
}
