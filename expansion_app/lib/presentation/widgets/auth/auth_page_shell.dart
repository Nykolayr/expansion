import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_compact_skew_button.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/layout/game_sticky_bottom_bar.dart';

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    required this.title,
    required this.child,
    required this.bottomBar,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.splashBackground, fit: BoxFit.cover),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameScreenBackBar(title: title),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    16,
                    24,
                    GameStickyBottomBar.scrollPadding(context),
                  ),
                  child: child,
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GameStickyBottomBar(child: bottomBar),
          ),
        ],
      ),
    );
  }
}

class AuthLinkRow extends StatelessWidget {
  const AuthLinkRow({
    required this.prompt,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Gap(8),
        Text(
          prompt,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Gap(8),
        Center(
          child: GameLongButton(
            label: actionLabel,
            fontSize: 16,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GameLongButton(
        label: label,
        loading: loading,
        onPressed: onPressed,
      ),
    );
  }
}

class AuthSecondaryButton extends StatelessWidget {
  const AuthSecondaryButton({
    required this.label,
    required this.onPressed,
    this.labelColor,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GameCompactSkewButton(
        label: label,
        fullWidth: true,
        fontSize: 15,
        labelColor: labelColor,
        onPressed: onPressed,
      ),
    );
  }
}

class AuthFormGap extends StatelessWidget {
  const AuthFormGap({this.size = 16, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => Gap(size);
}
