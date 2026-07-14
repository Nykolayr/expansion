import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';

/// Оплата СБП внутри приложения — страница T‑Bank без выхода в браузер.
class DonatePaymentWebViewPage extends StatefulWidget {
  const DonatePaymentWebViewPage({required this.url, super.key});

  final String url;

  @override
  State<DonatePaymentWebViewPage> createState() => _DonatePaymentWebViewPageState();
}

class _DonatePaymentWebViewPageState extends State<DonatePaymentWebViewPage> {
  WebViewController? _controller;
  var _loading = true;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    final uri = Uri.tryParse(widget.url);
    if (uri == null || uri.scheme != 'http' && uri.scheme != 'https') {
      if (mounted) {
        setState(() {
          _failed = true;
          _loading = false;
        });
      }
      return;
    }

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(ExpansionColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (_) {
            if (mounted) {
              setState(() {
                _loading = false;
                _failed = true;
              });
            }
          },
          onNavigationRequest: (request) {
            final target = Uri.tryParse(request.url);
            if (target == null) return NavigationDecision.prevent;
            if (target.scheme == 'http' || target.scheme == 'https') {
              return NavigationDecision.navigate;
            }
            launchUrl(target, mode: LaunchMode.externalApplication);
            return NavigationDecision.prevent;
          },
        ),
      );

    await controller.loadRequest(uri);

    if (!mounted) return;
    setState(() {
      _controller = controller;
      _loading = true;
      _failed = false;
    });
  }

  Future<void> _openInBrowser() async {
    final uri = Uri.tryParse(widget.url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final controller = _controller;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const GameMenuBackdrop(),
          GameMenuTheme(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GameScreenBackBar(title: loc.donatePaymentWebViewTitle),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ColoredBox(
                        color: Colors.white,
                        child: _failed || controller == null
                            ? _ErrorBody(
                                message: loc.donatePaymentWebViewFailed,
                                retryLabel: loc.donatePaymentRetry,
                                browserLabel: loc.donatePaymentWebViewOpenBrowser,
                                onRetry: _initWebView,
                                onOpenBrowser: _openInBrowser,
                              )
                            : Stack(
                                fit: StackFit.expand,
                                children: [
                                  WebViewWidget(controller: controller),
                                  if (_loading)
                                    const Center(child: CircularProgressIndicator()),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Text(
                    loc.donatePaymentWebViewHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ExpansionColors.grey,
                    ),
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

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.message,
    required this.retryLabel,
    required this.browserLabel,
    required this.onRetry,
    required this.onOpenBrowser,
  });

  final String message;
  final String retryLabel;
  final String browserLabel;
  final VoidCallback onRetry;
  final VoidCallback onOpenBrowser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            const Gap(16),
            GameLongButton(label: retryLabel, onPressed: onRetry),
            const Gap(12),
            GameLongButton(
              label: browserLabel,
              fontSize: 16,
              onPressed: onOpenBrowser,
            ),
          ],
        ),
      ),
    );
  }
}
