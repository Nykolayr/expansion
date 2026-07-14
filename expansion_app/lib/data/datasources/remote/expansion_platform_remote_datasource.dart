import 'package:dio/dio.dart';

import 'package:expansion/core/monetization/monetization_config.dart';

/// Результат создания намерения оплаты (СБП/QR).
class PaymentIntentResult {
  const PaymentIntentResult({
    required this.id,
    required this.paymentCode,
    required this.productId,
    required this.productLabel,
    required this.priceRub,
    this.sbpUrl,
    this.qrUrl,
  });

  final String id;
  final String paymentCode;
  final String productId;
  final String productLabel;
  final int priceRub;
  final String? sbpUrl;
  final String? qrUrl;
}

/// Бенефиты с сервера после guest/sync.
class GuestSyncBenefits {
  const GuestSyncBenefits({
    required this.adsRemoved,
    required this.supporterTier,
  });

  final bool adsRemoved;
  final int supporterTier;
}

/// Публичные вызовы платформы Expansion на VPS.
class ExpansionPlatformRemoteDataSource {
  ExpansionPlatformRemoteDataSource(this._dio);

  final Dio _dio;

  Future<({
    bool adsEnabled,
    bool donationsEnabled,
    String? paymentSbpUrl,
    String? paymentQrUrl,
  })> fetchConfig() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/expansion/config',
      options: Options(extra: const {'skipAuth': true}),
    );
    final data = response.data ?? {};
    final payment = data['payment'] as Map<String, dynamic>? ?? {};
    return (
      adsEnabled: data['adsEnabled'] as bool? ?? true,
      donationsEnabled: data['donationsEnabled'] as bool? ?? true,
      paymentSbpUrl: payment['sbpUrl'] as String?,
      paymentQrUrl: payment['qrUrl'] as String?,
    );
  }

  Future<GuestSyncBenefits?> syncGuest({
    required String deviceId,
    required Map<String, dynamic> profile,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/expansion/guest/sync',
      data: {'deviceId': deviceId, 'profile': profile},
      options: Options(extra: const {'skipAuth': true}),
    );
    final benefits = response.data?['benefits'] as Map<String, dynamic>?;
    if (benefits == null) return null;
    return GuestSyncBenefits(
      adsRemoved: benefits['adsRemoved'] as bool? ?? false,
      supporterTier: benefits['supporterTier'] as int? ?? 0,
    );
  }

  Future<PaymentIntentResult> createPaymentIntent({
    required String deviceId,
    required String productId,
    String? nick,
    String? email,
    String? ideaId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/expansion/donations/payment-intent',
      data: {
        'deviceId': deviceId,
        'productId': productId,
        if (nick != null && nick.isNotEmpty) 'nick': nick,
        if (email != null && email.isNotEmpty) 'email': email,
        if (ideaId != null && ideaId.isNotEmpty) 'ideaId': ideaId,
      },
    );
    final data = response.data ?? {};
    final payment = data['payment'] as Map<String, dynamic>? ?? {};
    return PaymentIntentResult(
      id: data['id'] as String? ?? '',
      paymentCode: data['paymentCode'] as String? ?? '',
      productId: data['productId'] as String? ?? productId,
      productLabel: data['productLabel'] as String? ?? productId,
      priceRub: (data['priceRub'] as num?)?.toInt()
          ?? MonetizationConfig.priceRubFor(productId),
      sbpUrl: payment['sbpUrl'] as String?,
      qrUrl: payment['qrUrl'] as String?,
    );
  }

  Future<void> reportPurchase({
    required String deviceId,
    required String productId,
    String store = 'unknown',
    String? userId,
    double? priceRub,
    String? ideaId,
  }) async {
    await _dio.post<void>(
      '/expansion/events/purchase',
      data: {
        'deviceId': deviceId,
        'productId': productId,
        'store': store,
        'userId': ?userId,
        'priceRub': ?priceRub,
        'ideaId': ?ideaId,
      },
      options: Options(extra: const {'skipAuth': true}),
    );
  }

  /// Черновик идеи к tier3. Для JWT email берётся с сервера.
  Future<String> submitDonationIdea({
    required String deviceId,
    required String ideaText,
    String? email,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/expansion/donations/idea',
      data: {
        'deviceId': deviceId,
        'ideaText': ideaText,
        if (email != null && email.isNotEmpty) 'email': email,
      },
    );
    final id = response.data?['id'] as String?;
    if (id == null || id.isEmpty) {
      throw StateError('donation idea id missing');
    }
    return id;
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
