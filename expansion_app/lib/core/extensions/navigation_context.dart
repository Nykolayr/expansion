import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Типобезопасные переходы (см. [app_router]).
extension AppNavigationX on BuildContext {
  void goHome() => go('/');

  void goToSplash() => go('/');

  /// Карта кампании — всегда [go], без стека боёв под ней.
  void goToMaps() => go('/maps');

  void goToSettings() => push('/settings');

  void goToHelp() => push('/help');

  void goToDonate() => push('/donate');

  void goToIntroStory() => push('/intro-story');

  void goToBegin() => push('/begin');

  /// Отдельный маршрут на каждый бой; после победы вызывай [goToMaps].
  void goToBattle({required int sceneId}) => push('/battle/$sceneId');

  /// Старт с экрана begin — без begin в стеке «назад».
  void replaceWithBattle({required int sceneId}) =>
      pushReplacement('/battle/$sceneId');

  void goToProfile() => push('/profile');

  void goToProfileAccountEdit({
    required String realName,
    required String nick,
    required String email,
  }) =>
      push(
        '/profile/account',
        extra: {
          'realName': realName,
          'nick': nick,
          'email': email,
        },
      );

  void goToProgress() => push('/progress');

  void goToUpgrades() => push('/upgrades');

  void goToAuthLogin({String? email}) {
    final trimmed = email?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      push('/auth/login?email=${Uri.encodeComponent(trimmed)}');
      return;
    }
    push('/auth/login');
  }

  void goToAuthRegister() => push('/auth/register');

  void goToAuthForgot() => push('/auth/forgot');

  void goToLeaderboard() => push('/leaderboard');

  void goToSupporters() => push('/supporters');
}
