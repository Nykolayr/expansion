/// Новая механика — оверлей в начале миссии (очередь, если несколько).
enum MissionFeatureIntro {
  mediumBase,
  largeBase,
  richBase,
  shieldedBase,
  factoryBase,
  bunkerBase,
  asteroid,
  comet,
  debris,
  pulse,
  drone;

  String get storageKey => name;

  /// Показывать интро на [sceneId]: нет при реплее пройденной миссии;
  /// если уже показывали, но миссию не прошли — снова.
  static bool shouldShowAtMission({
    required int sceneId,
    required int mapClassic,
    required bool isMapReplay,
    required bool hasSeenIntro,
  }) {
    if (isMapReplay) return false;
    if (!hasSeenIntro) return true;
    return sceneId >= mapClassic;
  }

  /// Интро для первого появления механики на кампании (м1–10).
  static List<MissionFeatureIntro> forScene(
    int sceneId, {
    required bool mission1TutorialCompleted,
  }) {
    return switch (sceneId) {
      1 when mission1TutorialCompleted => [MissionFeatureIntro.asteroid],
      2 => [MissionFeatureIntro.mediumBase],
      3 => [MissionFeatureIntro.comet],
      4 => [MissionFeatureIntro.largeBase],
      5 => [MissionFeatureIntro.richBase, MissionFeatureIntro.debris],
      6 => [MissionFeatureIntro.shieldedBase],
      7 => [MissionFeatureIntro.factoryBase, MissionFeatureIntro.pulse],
      8 => [MissionFeatureIntro.bunkerBase],
      9 => [MissionFeatureIntro.drone],
      _ => const [],
    };
  }
}
