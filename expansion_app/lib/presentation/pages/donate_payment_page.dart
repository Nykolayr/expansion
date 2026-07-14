import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/monetization/donate_billing_service.dart';
import 'package:expansion/core/monetization/monetization_config.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/data/datasources/remote/expansion_platform_remote_datasource.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/services/expansion_platform_sync_service.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expansion/core/constants/prefs_keys.dart';

/// Экран оплаты СБП/QR после выбора доната.
class DonatePaymentPage extends StatefulWidget {
  const DonatePaymentPage({required this.sku, super.key});

  final DonateSku sku;

  @override
  State<DonatePaymentPage> createState() => _DonatePaymentPageState();
}

class _DonatePaymentPageState extends State<DonatePaymentPage> {
  PaymentIntentResult? _intent;
  var _loading = true;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    _createIntent();
  }

  Future<void> _createIntent() async {
    setState(() {
      _loading = true;
      _failed = false;
    });

    final prefs = sl<SharedPreferences>();
    String? ideaId;
    if (widget.sku == DonateSku.tier3) {
      ideaId = prefs.getString(PrefsKeys.pendingDonationIdeaId);
    }

    final intent = await sl<ExpansionPlatformSyncService>().createPaymentIntent(
      productId: DonateBillingService.productIdFor(widget.sku),
      ideaId: ideaId,
    );

    if (!mounted) return;
    setState(() {
      _intent = intent;
      _loading = false;
      _failed = intent == null;
    });
  }

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.donatePaymentCodeCopied)),
    );
  }

  void _openSbp(String url) {
    context.pushNamed('donatePaymentWebView', extra: url);
  }

  String _priceLabel(AppLocalizations loc) {
    final rub = switch (widget.sku) {
      DonateSku.tier1 => MonetizationConfig.priceTier1Rub,
      DonateSku.tier2 => MonetizationConfig.priceTier2Rub,
      DonateSku.tier3 => MonetizationConfig.priceTier3Rub,
      DonateSku.removeAds => MonetizationConfig.priceRemoveAdsRub,
    };
    return MonetizationConfig.priceLabelRub(rub);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final intent = _intent;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const GameMenuBackdrop(),
          GameMenuTheme(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GameScreenBackBar(title: loc.donatePaymentTitle),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    children: [
                      if (_loading) ...[
                        const Center(child: CircularProgressIndicator()),
                        const Gap(16),
                        Text(
                          loc.donatePaymentLoading,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ] else if (_failed || intent == null) ...[
                        Text(
                          loc.donatePurchaseFailed,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const Gap(16),
                        GameLongButton(
                          label: loc.donatePaymentRetry,
                          onPressed: _createIntent,
                        ),
                      ] else ...[
                        Text(
                          intent.productLabel,
                          style: theme.textTheme.titleLarge,
                        ),
                        const Gap(8),
                        Text(
                          loc.donatePaymentAmount(_priceLabel(loc)),
                          style: theme.textTheme.bodyLarge,
                        ),
                        const Gap(24),
                        Text(
                          loc.donatePaymentInstructions,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const Gap(16),
                        Card(
                          color: ExpansionColors.background.withValues(alpha: 0.92),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  loc.donatePaymentCommentLabel,
                                  style: theme.textTheme.labelLarge,
                                ),
                                const Gap(8),
                                SelectableText(
                                  intent.paymentCode,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    color: ExpansionColors.accent,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const Gap(12),
                                GameLongButton(
                                  label: loc.donatePaymentCopyCode,
                                  onPressed: () => _copyCode(intent.paymentCode),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (intent.qrUrl != null && intent.qrUrl!.isNotEmpty) ...[
                          const Gap(24),
                          Text(
                            loc.donatePaymentQrHint,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ExpansionColors.grey,
                            ),
                          ),
                          const Gap(12),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                intent.qrUrl!,
                                width: 220,
                                height: 220,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Text(
                                  loc.donatePaymentQrMissing,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (intent.sbpUrl != null && intent.sbpUrl!.isNotEmpty) ...[
                          const Gap(16),
                          GameLongButton(
                            label: loc.donatePaymentOpenSbp,
                            onPressed: () => _openSbp(intent.sbpUrl!),
                          ),
                        ] else if (intent.qrUrl == null || intent.qrUrl!.isEmpty) ...[
                          const Gap(16),
                          Text(
                            loc.donatePaymentLinksPending,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ExpansionColors.grey,
                            ),
                          ),
                        ],
                        const Gap(24),
                        Text(
                          loc.donatePaymentAfterPay,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ExpansionColors.grey,
                          ),
                        ),
                        const Gap(16),
                        GameLongButton(
                          label: loc.donatePaymentBack,
                          fontSize: 16,
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
