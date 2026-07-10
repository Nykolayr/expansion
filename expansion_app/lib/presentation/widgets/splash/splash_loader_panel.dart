import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/splash/splash_state.dart';

/// Нижняя полоса загрузки на splash.
class SplashLoaderPanel extends StatelessWidget {
  const SplashLoaderPanel({
    required this.state,
    this.footer,
    super.key,
  });

  final SplashState state;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    if (state.isSuccess) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 4,
        right: 4,
        bottom: bottomSafe + 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            loc.splashLoadLabel,
            style: ExpansionTextStyles.bodyOnDark(context, 16),
          ),
          const Gap(12),
          _ProgressBar(count: state.count),
          if (footer != null) ...[
            const Gap(8),
            footer!,
          ],
          const Gap(16),
        ],
      ),
    );
  }
}

/// Полоса заполнения слева направо (legacy `Loader` Stack без center).
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    const barWidth = 220.0;
    const barHeight = 18.0;
    final fillWidth = barWidth * (1 - count / 100);

    return SizedBox(
      width: barWidth,
      height: barHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: ExpansionColors.accent, width: 2),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: fillWidth,
            child: const ColoredBox(color: ExpansionColors.accent),
          ),
        ],
      ),
    );
  }
}
