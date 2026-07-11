/// Темп боя (тики, задержки, скорости движения).
abstract final class BattlePacing {
  /// ~20 FPS — спокойнее для тактики.
  static const Duration tickInterval = Duration(milliseconds: 48);

  /// Первая миссия: чужие не ходят первые N секунд.
  static const Duration firstBattleEnemyGrace = Duration(seconds: 10);

  /// После онбординга миссии 1 — ещё N секунд без хода врага.
  static const Duration postTutorialEnemyGrace = Duration(seconds: 5);

  /// Прогресс пути флота за тик на **1 клетку** сетки — база для расчёта скорости.
  /// Фактический шаг = [baseFleetProgressPerGridCell] / расстояние в клетках.
  static const double baseFleetProgressPerGridCell = 0.04;

  /// @deprecated Используй [baseFleetProgressPerGridCell].
  static const double fleetProgressPerTick = baseFleetProgressPerGridCell;

  /// Доход ресурсов базы за тик (× speedResources базы).
  static const double resourceIncomePerTick = 0.4;

  static const double asteroidProgressPerTick = 0.013;
  static const double debrisProgressPerTick = 0.009;
  static const double cometProgressPerTick = 0.021;
  static const double pulseProgressPerTick = 0.024;
  static const double solarWindProgressPerTick = 0.011;
  static const double wormholeProgressPerTick = 0.019;
  static const int asteroidSpawnIntervalTicks = 900;
}
