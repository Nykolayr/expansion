import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/audio/game_audio_service.dart';
import 'package:expansion/core/constants/asset_paths.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';

/// Широкая кнопка со скосом (`bottom_long.svg`) — единственный вид одиночных действий.
class GameLongButton extends StatelessWidget {
  const GameLongButton({
    required this.label,
    required this.onPressed,
    this.fontSize = 20,
    this.loading = false,
    this.maxWidth,
    this.labelColor,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final double fontSize;
  final bool loading;
  final double? maxWidth;
  final Color? labelColor;

  static const double _svgAspect = 1109.81 / 8527.74;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;

    return LayoutBuilder(
      builder: (context, constraints) {
        final fallback = MediaQuery.sizeOf(context).width - 30;
        final width = maxWidth ??
            (constraints.maxWidth.isFinite && constraints.maxWidth > 0
                ? constraints.maxWidth
                : fallback);
        final height = (width * _svgAspect).clamp(44.0, 72.0);

        return Opacity(
          opacity: enabled ? 1 : 0.45,
          child: GestureDetector(
            onTap: enabled ? () => _onTap(onPressed!) : null,
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    AssetPaths.svg('bottom_long.svg'),
                    width: width,
                    height: height,
                    fit: BoxFit.fill,
                  ),
                  if (loading)
                    const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: ExpansionTextStyles.bodyAccent(context, fontSize)
                            .copyWith(
                          color: labelColor ??
                              (onPressed != null ? null : ExpansionColors.grey),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTap(VoidCallback action) {
    sl<GameAudioService>().playUiClick();
    action();
  }
}
