/// Базовый URL API. Переопределяется при запуске:
/// `flutter run --dart-define=API_BASE_URL=https://expansion-api.danilagames.ru/api`
///
/// По умолчанию — prod VPS по IP (HTTP). После DNS + certbot — HTTPS-поддомен.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://46.173.25.193/api',
  );
}
