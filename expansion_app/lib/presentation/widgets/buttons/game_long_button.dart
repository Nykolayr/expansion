import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/audio/game_audio_service.dart';
import 'package:expansion/core/constants/asset_paths.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';

/// Широкая кнопка со скосом (`bottom_long.svg`) — стиль меню splash.
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

  @override
  Widget build(BuildContext context) {
    final width = maxWidth ?? MediaQuery.sizeOf(context).width - 30;
    final enabled = onPressed != null && !loading;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTap: enabled ? () => _onTap(onPressed!) : null,
        child: SizedBox(
          width: width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                AssetPaths.svg('bottom_long.svg'),
                width: width,
                fit: BoxFit.fitWidth,
              ),
              if (loading)
                const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Text(
                  label,
                  style: ExpansionTextStyles.bodyAccent(context, fontSize).copyWith(
                    color: labelColor ??
                        (onPressed != null ? null : ExpansionColors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(VoidCallback action) {
    sl<GameAudioService>().playUiClick();
    action();
  }
}
