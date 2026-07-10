/// Темп боя (тики, задержки, скорости движения).
abstract final class BattlePacing {
  /// ~20 FPS — спокойнее для тактики.
  static const Duration tickInterval = Duration(milliseconds: 48);

  /// Первая миссия: чужие не ходят первые N секунд.
  static const Duration firstBattleEnemyGrace = Duration(seconds: 10);

  static const double fleetProgressPerTick = 0.014;
  static const double asteroidProgressPerTick = 0.013;
  static const int asteroidSpawnIntervalTicks = 900;
}
