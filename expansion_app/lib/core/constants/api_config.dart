/// Базовый URL API. Переопределяется при запуске:
/// `flutter run --dart-define=API_BASE_URL=https://api.myapp.com`
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );
}
