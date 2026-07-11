/// Новая механика, которую показываем один раз при старте миссии.
enum MissionFeatureIntro {
  mediumBase,
  largeBase;

  String get storageKey => name;

  static MissionFeatureIntro? forScene(int sceneId) {
    return switch (sceneId) {
      2 => MissionFeatureIntro.mediumBase,
      4 => MissionFeatureIntro.largeBase,
      _ => null,
    };
  }
}
