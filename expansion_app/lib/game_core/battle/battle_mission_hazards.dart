/// Какие hazard'ы активны на миссии (по sceneId). Новые типы — по мере реализации.
abstract final class BattleMissionHazards {
  static bool asteroidsEnabled(int sceneId) => sceneId >= 1;

  /// Тиков между спавнами астероида.
  static int asteroidSpawnIntervalTicks(int sceneId) {
    return switch (sceneId) {
      1 => 1200,
      2 => 1500,
      <= 3 => 1200,
      <= 10 => 1050,
      _ => 900,
    };
  }
}
