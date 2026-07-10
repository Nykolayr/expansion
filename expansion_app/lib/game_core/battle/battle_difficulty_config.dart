import 'package:expansion/domain/enums/game_difficulty.dart';

/// Темп AI и множители скорости сторон по сложности.
class BattleDifficultyConfig {
  const BattleDifficultyConfig({
    required this.ticksPerEnemyTurn,
    required this.playerFleetSpeedMul,
    required this.enemyFleetSpeedMul,
    required this.enemyGrowthSpeedMul,
  });

  factory BattleDifficultyConfig.forDifficulty(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return const BattleDifficultyConfig(
          ticksPerEnemyTurn: 150,
          playerFleetSpeedMul: 1.08,
          enemyFleetSpeedMul: 0.9,
          enemyGrowthSpeedMul: 0.9,
        );
      case GameDifficulty.average:
        return const BattleDifficultyConfig(
          ticksPerEnemyTurn: 100,
          playerFleetSpeedMul: 1,
          enemyFleetSpeedMul: 1,
          enemyGrowthSpeedMul: 1,
        );
      case GameDifficulty.difficult:
        return const BattleDifficultyConfig(
          ticksPerEnemyTurn: 68,
          playerFleetSpeedMul: 1,
          enemyFleetSpeedMul: 1.08,
          enemyGrowthSpeedMul: 1.08,
        );
    }
  }

  final int ticksPerEnemyTurn;
  final double playerFleetSpeedMul;
  final double enemyFleetSpeedMul;
  final double enemyGrowthSpeedMul;
}
