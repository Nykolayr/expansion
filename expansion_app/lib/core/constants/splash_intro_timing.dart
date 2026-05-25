/// Тайминг вступления на splash (синхрон с [SplashPretextTyper]).
abstract final class SplashIntroTiming {
  static const int msPerChar = 28;

  /// Пауза с полным текстом перед дозаполнением полосы.
  static const int holdFullTextMs = 1000;

  /// Быстрое дозаполнение оставшейся части полосы после паузы.
  static const int barFinishMs = 500;

  /// Какую долю полосы заполнять во время печати (остальное — в конце).
  static const double typingBarShare = 0.22;

  /// Имитация загрузки без вступительного текста (до API).
  static const int skipIntroLoadMs = 2000;
}
