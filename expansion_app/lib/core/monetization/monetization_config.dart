import 'package:flutter/foundation.dart';

/// ID рекламных блоков и IAP. В release подставляются через `--dart-define`.
abstract final class MonetizationConfig {
  static const String bannerAdUnitId = String.fromEnvironment(
    'YANDEX_BANNER_AD_UNIT',
    defaultValue: 'demo-banner-yandex',
  );

  static const String interstitialAdUnitId = String.fromEnvironment(
    'YANDEX_INTERSTITIAL_AD_UNIT',
    defaultValue: 'demo-interstitial-yandex',
  );

  static const String rewardedAdUnitId = String.fromEnvironment(
    'YANDEX_REWARDED_AD_UNIT',
    defaultValue: 'demo-rewarded-yandex',
  );

  static const String productDonateTier1 = String.fromEnvironment(
    'IAP_DONATE_TIER1',
    defaultValue: 'com.ryjovs.expansion.donate_tier1',
  );

  static const String productDonateTier2 = String.fromEnvironment(
    'IAP_DONATE_TIER2',
    defaultValue: 'com.ryjovs.expansion.donate_tier2',
  );

  static const String productDonateTier3 = String.fromEnvironment(
    'IAP_DONATE_TIER3',
    defaultValue: 'com.ryjovs.expansion.donate_tier3',
  );

  static const String productRemoveAds = String.fromEnvironment(
    'IAP_REMOVE_ADS',
    defaultValue: 'com.ryjovs.expansion.remove_ads',
  );

  /// Фиксированные цены для UI (₽). Оплата позже — RuStore / СБП.
  static const int priceTier1Rub = 99;
  static const int priceTier2Rub = 299;
  static const int priceTier3Rub = 599;
  static const int priceRemoveAdsRub = 199;

  static int priceRubFor(String productId) => switch (productId) {
        productDonateTier1 => priceTier1Rub,
        productDonateTier2 => priceTier2Rub,
        productDonateTier3 => priceTier3Rub,
        productRemoveAds => priceRemoveAdsRub,
        _ => 0,
      };

  static String priceLabelRub(int rub) => '$rub ₽';

  static const int interstitialMinBattles = 3;
  static const Duration interstitialMinInterval = Duration(minutes: 5);

  /// Бонус к очкам за победу после rewarded (+50%).
  static const double victoryRewardedBonusFactor = 0.5;

  static bool get usesDemoAdUnits =>
      kDebugMode &&
      bannerAdUnitId.startsWith('demo-') &&
      interstitialAdUnitId.startsWith('demo-') &&
      rewardedAdUnitId.startsWith('demo-');

  static Set<String> get allProductIds => {
        productDonateTier1,
        productDonateTier2,
        productDonateTier3,
        productRemoveAds,
      };
}
