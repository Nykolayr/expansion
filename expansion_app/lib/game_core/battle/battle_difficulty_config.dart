import 'package:expansion/domain/enums/game_difficulty.dart';

/// Темп AI и множители скорости сторон по сложности.
///
/// Лёгкая — бывшая «средняя» (темп без ускорений).
/// Средняя — умнее AI (чаще ходит), без бонусов скорости.
/// Сложная — умный AI + ускорение флота/роста врага.
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
          ticksPerEnemyTurn: 100,
          playerFleetSpeedMul: 1,
          enemyFleetSpeedMul: 1,
          enemyGrowthSpeedMul: 1,
        );
      case GameDifficulty.average:
        return const BattleDifficultyConfig(
          ticksPerEnemyTurn: 72,
          playerFleetSpeedMul: 1,
          enemyFleetSpeedMul: 1,
          enemyGrowthSpeedMul: 1,
        );
      case GameDifficulty.difficult:
        return const BattleDifficultyConfig(
          ticksPerEnemyTurn: 58,
          playerFleetSpeedMul: 1,
          enemyFleetSpeedMul: 1.1,
          enemyGrowthSpeedMul: 1.12,
        );
    }
  }

  final int ticksPerEnemyTurn;
  final double playerFleetSpeedMul;
  final double enemyFleetSpeedMul;
  final double enemyGrowthSpeedMul;
}
