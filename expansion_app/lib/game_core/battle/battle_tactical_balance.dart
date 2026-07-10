/// Баланс тактических апгрейдов внутри боя.
abstract final class BattleTacticalBalance {
  /// Тиков на +1 корабль при базовой скорости (speedBuild 0.1, без апгрейда).
  static const int baseShipGrowthTicks = 28;

  /// Множитель скорости постройки по уровню тактического апгрейда.
  /// Индекс = [BattleBase.buildUpgradeLevel].
  static const List<double> buildSpeedMultipliers = [
    1.0,
    1.3,
    1.5,
    2.0,
    2.5,
    3.0,
  ];

  static double buildSpeedMultiplierForLevel(int level) {
    final index = level.clamp(0, buildSpeedMultipliers.length - 1);
    return buildSpeedMultipliers[index];
  }

  /// Тиков до следующего корабля.
  static int shipGrowthThresholdTicks({
    required double speedBuild,
    required int buildUpgradeLevel,
    required double growthMul,
  }) {
    final speedFactor = speedBuild / 0.1;
    final buildMul = buildSpeedMultiplierForLevel(buildUpgradeLevel);
    final divisor = speedFactor * growthMul * buildMul;
    if (divisor <= 0) return baseShipGrowthTicks;
    return (baseShipGrowthTicks / divisor).round().clamp(3, 60);
  }

  static String formatBuildMultiplier(int level) {
    final value = buildSpeedMultiplierForLevel(level);
    if (value == value.roundToDouble()) {
      return '${value.toInt()}×';
    }
    return '${value.toStringAsFixed(1)}×';
  }
}
