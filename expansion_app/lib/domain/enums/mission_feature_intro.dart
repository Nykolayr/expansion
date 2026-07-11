/// Новая механика, которую показываем один раз при старте миссии.
enum MissionFeatureIntro {
  mediumBase,
  largeBase,
  richBase;

  String get storageKey => name;

  static MissionFeatureIntro? forScene(int sceneId) {
    return switch (sceneId) {
      2 => MissionFeatureIntro.mediumBase,
      4 => MissionFeatureIntro.largeBase,
      5 => MissionFeatureIntro.richBase,
      _ => null,
    };
  }
}
