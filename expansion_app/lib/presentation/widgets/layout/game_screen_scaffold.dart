import 'package:flutter/material.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';

/// Общий каркас игрового экрана: фон, «назад», заголовок и тело или текст-заглушка.
class GameScreenScaffold extends StatelessWidget {
  const GameScreenScaffold({
    required this.title,
    this.body,
    this.placeholderMessage,
    super.key,
  }) : assert(
          body != null || placeholderMessage != null,
          'Provide body or placeholderMessage',
        );

  final String title;
  final Widget? body;
  final String? placeholderMessage;

  @override
  Widget build(BuildContext context) {
    final content = body ??
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Card(
              color: ExpansionColors.background.withValues(alpha: 0.92),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: ExpansionColors.accent,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  placeholderMessage!,
                  style: ExpansionTextStyles.bodyOnDark(context, 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const GameMenuBackdrop(),
          GameMenuTheme(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GameScreenBackBar(title: title),
                Expanded(child: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
