import 'package:expansion/core/constants/secure_storage_keys.dart';
import 'package:expansion/core/storage/secure_storage_service.dart';

/// JWT access/refresh — только secure storage, не prefs.
class AuthTokenStorage {
  AuthTokenStorage(this._secureStorage);

  final SecureStorageService _secureStorage;

  Future<String?> readAccessToken() =>
      _secureStorage.read(SecureStorageKeys.accessToken);

  Future<String?> readRefreshToken() =>
      _secureStorage.read(SecureStorageKeys.refreshToken);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(SecureStorageKeys.accessToken, accessToken);
    await _secureStorage.write(SecureStorageKeys.refreshToken, refreshToken);
  }

  Future<void> clear() async {
    await _secureStorage.delete(SecureStorageKeys.accessToken);
    await _secureStorage.delete(SecureStorageKeys.refreshToken);
  }

  Future<bool> hasRefreshToken() async {
    final token = await readRefreshToken();
    return token != null && token.isNotEmpty;
  }
}
