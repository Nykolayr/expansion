import 'package:expansion/domain/enums/game_difficulty.dart';

/// Темп AI между ходами ([BattleCubit] тиках).
class BattleDifficultyConfig {
  const BattleDifficultyConfig({required this.ticksPerEnemyTurn});

  factory BattleDifficultyConfig.forDifficulty(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return const BattleDifficultyConfig(ticksPerEnemyTurn: 90);
      case GameDifficulty.average:
        return const BattleDifficultyConfig(ticksPerEnemyTurn: 60);
      case GameDifficulty.difficult:
        return const BattleDifficultyConfig(ticksPerEnemyTurn: 40);
    }
  }

  final int ticksPerEnemyTurn;
}
