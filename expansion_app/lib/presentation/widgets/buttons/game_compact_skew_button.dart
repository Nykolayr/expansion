import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:expansion/core/constants/asset_paths.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';

/// Компактная кнопка со скосом (`bottom_middle_in.svg`) для строк и диалогов.
class GameCompactSkewButton extends StatelessWidget {
  const GameCompactSkewButton({
    required this.label,
    required this.onPressed,
    this.width = 120,
    this.height = 44,
    this.fontSize = 14,
    this.fullWidth = false,
    this.maxWidth,
    this.labelColor,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final double fontSize;
  final bool fullWidth;
  final double? maxWidth;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final buttonWidth = fullWidth
        ? (maxWidth ?? MediaQuery.sizeOf(context).width - 48)
        : width;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTap: enabled ? onPressed : null,
        child: SizedBox(
          width: buttonWidth,
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                AssetPaths.svg('bottom_middle_in.svg'),
                width: buttonWidth,
                height: height,
                fit: BoxFit.fill,
              ),
              Text(
                label,
                style: ExpansionTextStyles.bodyAccent(context, fontSize).copyWith(
                  color: labelColor ?? (enabled ? null : ExpansionColors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
