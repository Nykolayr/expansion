import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/core/monetization/monetization_config.dart';
import 'package:expansion/core/monetization/remote_monetization_service.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/services/expansion_platform_sync_service.dart';

enum DonateSku {
  tier1,
  tier2,
  tier3,
  removeAds,
}

/// Google Play / App Store IAP для донатов и «убрать рекламу».
class DonateBillingService {
  DonateBillingService(
    this._guestProfile,
    this._remoteMonetization,
    this._platformSync,
  );

  final GuestProfileRepository _guestProfile;
  final RemoteMonetizationService _remoteMonetization;
  final ExpansionPlatformSyncService _platformSync;
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  var _storeAvailable = false;

  Map<String, ProductDetails> _products = {};

  bool get isStoreAvailable => _storeAvailable;

  bool get donationsEnabled => _remoteMonetization.donationsEnabled;

  Future<void> init() async {
    if (kIsWeb) return;
    if (!(defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS)) {
      return;
    }

    _storeAvailable = await _iap.isAvailable();
    if (!_storeAvailable) {
      AppLog.trace('IAP store unavailable', tag: 'Billing');
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdates,
      onError: (Object e, StackTrace st) {
        AppLog.error('IAP stream error', error: e, stackTrace: st, tag: 'Billing');
      },
    );

    await refreshProducts();
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }

  Future<void> refreshProducts() async {
    if (!_storeAvailable) return;
    final response = await _iap.queryProductDetails(MonetizationConfig.allProductIds);
    if (response.error != null) {
      AppLog.trace('IAP query error: ${response.error}', tag: 'Billing');
    }
    _products = {for (final p in response.productDetails) p.id: p};
  }

  ProductDetails? productFor(DonateSku sku) => _products[_productId(sku)];

  String? priceLabelFor(DonateSku sku) => productFor(sku)?.price;

  Future<bool> purchase(DonateSku sku) async {
    if (!_remoteMonetization.donationsEnabled) return false;
    if (!_storeAvailable) return false;
    final product = productFor(sku);
    if (product == null) {
      await refreshProducts();
    }
    final details = productFor(sku);
    if (details == null) {
      AppLog.trace('IAP product missing: ${_productId(sku)}', tag: 'Billing');
      return false;
    }

    final purchaseParam = PurchaseParam(productDetails: details);
    if (sku == DonateSku.removeAds) {
      return _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
    return _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) continue;

      if (purchase.status == PurchaseStatus.error) {
        AppLog.trace('IAP purchase error: ${purchase.error}', tag: 'Billing');
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
        continue;
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _grantPurchase(purchase.productID);
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> _grantPurchase(String productId) async {
    final guest = await _guestProfile.load();
    if (productId == MonetizationConfig.productRemoveAds) {
      await _guestProfile.save(guest.copyWith(adsRemoved: true));
      AppLog.trace('IAP: ads removed', tag: 'Billing');
      unawaited(_platformSync.reportPurchaseByProductId(productId));
      return;
    }

    final tier = _tierForProduct(productId);
    if (tier <= 0) return;
    final newTier = tier > guest.supporterTier ? tier : guest.supporterTier;
    await _guestProfile.save(guest.copyWith(supporterTier: newTier));
    AppLog.trace('IAP: supporter tier $newTier', tag: 'Billing');
    unawaited(_platformSync.reportPurchaseByProductId(productId));
  }

  Future<void> restorePurchases() async {
    if (!_storeAvailable) return;
    await _iap.restorePurchases();
  }

  static String productIdFor(DonateSku sku) => _productId(sku);

  static String _productId(DonateSku sku) => switch (sku) {
        DonateSku.tier1 => MonetizationConfig.productDonateTier1,
        DonateSku.tier2 => MonetizationConfig.productDonateTier2,
        DonateSku.tier3 => MonetizationConfig.productDonateTier3,
        DonateSku.removeAds => MonetizationConfig.productRemoveAds,
      };

  static int _tierForProduct(String productId) => switch (productId) {
        MonetizationConfig.productDonateTier1 => 1,
        MonetizationConfig.productDonateTier2 => 2,
        MonetizationConfig.productDonateTier3 => 3,
        _ => 0,
      };
}
