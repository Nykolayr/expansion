import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

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
                    24 + MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  child: child,
                ),
              ),
            ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prompt, style: Theme.of(context).textTheme.bodyMedium),
        TextButton(onPressed: onPressed, child: Text(actionLabel)),
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
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
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
