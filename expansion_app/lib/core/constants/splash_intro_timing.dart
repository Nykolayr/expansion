/// Тайминг вступления на splash (синхрон с [SplashPretextTyper]).
abstract final class SplashIntroTiming {
  static const int msPerChar = 28;

  /// Пауза с полным текстом перед загрузкой БД.
  static const int holdFullTextMs = 2000;

  /// Быстрое дозаполнение оставшейся части полосы после паузы.
  static const int barFinishMs = 500;

  /// Какую долю полосы заполнять во время печати (остальное — в конце).
  static const double typingBarShare = 0.22;

  /// Верхняя граница анимации полосы до 95%, пока bootstrap не завершится.
  static const Duration progressAnimationCap = Duration(seconds: 12);
}
