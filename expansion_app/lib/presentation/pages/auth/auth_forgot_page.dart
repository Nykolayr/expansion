import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/auth/forgot_password_cubit.dart';
import 'package:expansion/presentation/bloc/auth/forgot_password_state.dart';
import 'package:expansion/presentation/widgets/auth/auth_messages.dart';
import 'package:expansion/presentation/widgets/auth/auth_page_shell.dart';
import 'package:expansion/presentation/widgets/forms/game_password_field.dart';

class AuthForgotPage extends StatefulWidget {
  const AuthForgotPage({super.key});

  @override
  State<AuthForgotPage> createState() => _AuthForgotPageState();
}

class _AuthForgotPageState extends State<AuthForgotPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => sl<ForgotPasswordCubit>(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listenWhen: (p, c) =>
            p.status != c.status || p.step != c.step,
        listener: (context, state) {
          if (state.status == ForgotStatus.failure) {
            sl<AppFeedbackService>().show(
              resolveAuthMessage(loc, state.errorMessage),
            );
          }
          if (state.step == ForgotStep.reset &&
              state.status != ForgotStatus.failure) {
            sl<AppFeedbackService>().show(
              loc.authResetSent,
              kind: AppFeedbackKind.success,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ForgotPasswordCubit>();
          final loading = state.status == ForgotStatus.loading;

          if (state.step == ForgotStep.reset) {
            return AuthPageShell(
              title: loc.authResetTitle,
              bottomBar: AuthPrimaryButton(
                label: loc.authResetAction,
                loading: loading,
                onPressed: () async {
                  final ok = await cubit.submitReset(
                    code: _codeController.text,
                    newPassword: _passwordController.text,
                  );
                  if (!context.mounted || !ok) return;
                  sl<AppFeedbackService>().show(
                    loc.authResetSuccess,
                    kind: AppFeedbackKind.success,
                  );
                  context.goToAuthLogin();
                },
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(loc.authResetBody(state.email)),
                  const AuthFormGap(),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: loc.authVerifyCode,
                      counterText: '',
                    ),
                  ),
                  const AuthFormGap(),
                  GamePasswordField(
                    controller: _passwordController,
                    labelText: loc.authNewPassword,
                    helperText: loc.authPasswordHint,
                  ),
                ],
              ),
            );
          }

          return AuthPageShell(
            title: loc.authForgotTitle,
            bottomBar: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthPrimaryButton(
                  label: loc.authForgotAction,
                  loading: loading,
                  onPressed: () {
                    cubit
                      ..updateEmail(_emailController.text)
                      ..submitEmail();
                  },
                ),
                const Gap(8),
                AuthSecondaryButton(
                  label: loc.authBackToLogin,
                  onPressed: () => context.goToAuthLogin(),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(loc.authForgotBody),
                const AuthFormGap(),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  onChanged: cubit.updateEmail,
                  decoration: InputDecoration(labelText: loc.authEmail),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
