import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/splash/splash_cubit.dart';
import 'package:expansion/presentation/bloc/splash/splash_state.dart';
import 'package:expansion/presentation/widgets/splash/splash_pretext_typer.dart';

/// Высота окна вступительного текста (фиксирована — не сжимается из‑за галочки).
const double kSplashStoryViewportHeight = 152;

/// Нижняя панель загрузки на splash (legacy `Loader`).
///
/// Сверху вниз: история → «загрузка…» → полоса → галочка.
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
    final width = MediaQuery.sizeOf(context).width;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    const reservedBottomMenu = 120.0;
    final maxPanelHeight = (MediaQuery.sizeOf(context).height -
            reservedBottomMenu -
            bottomSafe -
            80)
        .clamp(200.0, 420.0);

    if (state.isSuccess) {
      return const SizedBox.shrink();
    }

    final showPretext = state.showIntro;
    final cardWidth = width - 20;

    return Padding(
      padding: EdgeInsets.only(
        left: 4,
        right: 4,
        bottom: bottomSafe + 8,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxPanelHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showPretext)
              ClipRect(
                child: AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  width: cardWidth,
                  duration: const Duration(seconds: 2),
                  child: Card(
                    elevation: 10,
                    color: ExpansionColors.background,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: ExpansionColors.accent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.fromLTRB(10, 4, 10, 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        height: kSplashStoryViewportHeight,
                        child: SplashPretextTyper(
                          text: loc.splashPretext,
                          onProgress: sl<SplashCubit>().onTypingProgress,
                          onComplete:
                              sl<SplashCubit>().markIntroTypingComplete,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const Gap(8),
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
