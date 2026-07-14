import 'package:dio/dio.dart';

/// Публичные вызовы платформы Expansion на VPS.
class ExpansionPlatformRemoteDataSource {
  ExpansionPlatformRemoteDataSource(this._dio);

  final Dio _dio;

  Future<({bool adsEnabled, bool donationsEnabled})> fetchConfig() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/expansion/config',
      options: Options(extra: const {'skipAuth': true}),
    );
    final data = response.data ?? {};
    return (
      adsEnabled: data['adsEnabled'] as bool? ?? true,
      donationsEnabled: data['donationsEnabled'] as bool? ?? true,
    );
  }

  Future<void> syncGuest({
    required String deviceId,
    required Map<String, dynamic> profile,
  }) async {
    await _dio.post<void>(
      '/expansion/guest/sync',
      data: {'deviceId': deviceId, 'profile': profile},
      options: Options(extra: const {'skipAuth': true}),
    );
  }

  Future<void> reportPurchase({
    required String deviceId,
    required String productId,
    String store = 'unknown',
    String? userId,
    double? priceRub,
  }) async {
    await _dio.post<void>(
      '/expansion/events/purchase',
      data: {
        'deviceId': deviceId,
        'productId': productId,
        'store': store,
        'userId': ?userId,
        'priceRub': ?priceRub,
      },
      options: Options(extra: const {'skipAuth': true}),
    );
  }

  Future<void> reportAdEvents({
    required String deviceId,
    required List<String> eventTypes,
  }) async {
    if (eventTypes.isEmpty) return;
    await _dio.post<void>(
      '/expansion/events/ad',
      data: {
        'deviceId': deviceId,
        'events': eventTypes.map((t) => {'eventType': t}).toList(),
      },
      options: Options(extra: const {'skipAuth': true}),
    );
  }
}
