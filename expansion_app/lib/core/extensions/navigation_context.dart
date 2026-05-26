import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Типобезопасные переходы (дополняй по мере появления маршрутов в [app_router]).
extension AppNavigationX on BuildContext {
  void goHome() => go('/');

  void goToSplash() => go('/');

  void goToSettings() => push('/settings');

  void goToIntroStory() => push('/intro-story');

  void goToMaps() => push('/maps');

  void goToBegin() => push('/begin');

  void goToBattle({required int sceneId}) =>
      push('/battle', extra: sceneId);

  void goToProfile() => push('/profile');

  void goToProgress() => push('/progress');

  void goToUpgrades() => push('/upgrades');
}
