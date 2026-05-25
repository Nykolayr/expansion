import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Обёртка над [FlutterSecureStorage] для токенов и прочих секретов.
/// Не используй для кэша общих данных — только [SharedPreferences] или БД.
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);
}
