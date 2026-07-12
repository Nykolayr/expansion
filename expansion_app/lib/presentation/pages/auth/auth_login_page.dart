import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/auth/login_cubit.dart';
import 'package:expansion/presentation/bloc/auth/login_state.dart';
import 'package:expansion/presentation/services/auth_post_login_service.dart';
import 'package:expansion/presentation/widgets/auth/auth_messages.dart';
import 'package:expansion/presentation/widgets/auth/auth_page_shell.dart';
import 'package:expansion/presentation/widgets/auth/progress_merge_dialog.dart';

class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({super.key});

  @override
  State<AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSuccess(BuildContext context, LoginCubit cubit) async {
    final postLogin = sl<AuthPostLoginService>();
    final state = cubit.state;

    if (state.needsMerge) {
      final local = await postLogin.loadLocalProfile();
      final server = await postLogin.fetchServerProfile();
      if (!context.mounted) return;
      final choice = await ProgressMergeDialog.show(
        context,
        local: local,
        server: server,
      );
      if (choice == null || !context.mounted) return;
      await cubit.completeMerge(choice);
    }

    if (!context.mounted) return;
    sl<AppFeedbackService>().show(
      AppLocalizations.of(context)!.authLoginSuccess,
      kind: AppFeedbackKind.success,
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            sl<AppFeedbackService>().show(
              resolveAuthMessage(loc, state.errorMessage),
            );
          }
          if (state.status == LoginStatus.success) {
            _onSuccess(context, context.read<LoginCubit>());
          }
        },
        builder: (context, state) {
          final loading = state.status == LoginStatus.loading;

          return AuthPageShell(
            title: loc.authLoginTitle,
            bottomBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthPrimaryButton(
                  label: loc.authLoginAction,
                  loading: loading,
                  onPressed: () {
                    context.read<LoginCubit>().submit(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                  },
                ),
                const Gap(8),
                AuthSecondaryButton(
                  label: loc.authForgotLink,
                  onPressed: () => context.goToAuthForgot(),
                ),
                AuthLinkRow(
                  prompt: loc.authNoAccount,
                  actionLabel: loc.authRegisterAction,
                  onPressed: () => context.goToAuthRegister(),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: loc.authEmail,
                  ),
                ),
                const AuthFormGap(),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: loc.authPassword,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
