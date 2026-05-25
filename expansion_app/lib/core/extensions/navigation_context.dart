import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Типобезопасные переходы (дополняй по мере появления маршрутов в [app_router]).
///
/// Имена методов можно держать в унисон с `routing.mdc`: `goToLogin`, `goToUserProfile`, …
extension AppNavigationX on BuildContext {
  void goHome() => go('/');

  /// Пример: после добавления маршрута `/login`
  // void goToLogin() => go('/login');
}
