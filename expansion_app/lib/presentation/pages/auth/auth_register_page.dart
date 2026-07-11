import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/auth/register_cubit.dart';
import 'package:expansion/presentation/bloc/auth/register_state.dart';
import 'package:expansion/presentation/services/auth_post_login_service.dart';
import 'package:expansion/presentation/widgets/auth/auth_messages.dart';
import 'package:expansion/presentation/widgets/auth/auth_page_shell.dart';
import 'package:expansion/presentation/widgets/auth/progress_merge_dialog.dart';

class AuthRegisterPage extends StatefulWidget {
  const AuthRegisterPage({super.key});

  @override
  State<AuthRegisterPage> createState() => _AuthRegisterPageState();
}

class _AuthRegisterPageState extends State<AuthRegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nickController = TextEditingController();
  final _realNameController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillRealName();
  }

  Future<void> _prefillRealName() async {
    final profile = await sl<GuestProfileRepository>().load();
    final name = profile.displayName.trim();
    if (name.isNotEmpty && mounted) {
      _realNameController.text = name;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nickController.dispose();
    _realNameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onSuccess(BuildContext context, RegisterCubit cubit) async {
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
      AppLocalizations.of(context)!.authRegisterSuccess,
      kind: AppFeedbackKind.success,
    );
    context.pop();
  }

  Widget _nickHelper(AppLocalizations loc, RegisterState state) {
    return switch (state.nickStatus) {
      NickCheckStatus.checking => Text(loc.authNickChecking),
      NickCheckStatus.available => Text(
          loc.authNickAvailable,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      NickCheckStatus.unavailable => Text(
          nickAvailabilityHint(loc, state.nickReason),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      NickCheckStatus.idle => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (p, c) =>
            p.status != c.status || p.step != c.step,
        listener: (context, state) {
          if (state.status == RegisterStatus.failure) {
            sl<AppFeedbackService>().show(
              resolveAuthMessage(loc, state.errorMessage),
            );
          }
          if (state.status == RegisterStatus.success) {
            _onSuccess(context, context.read<RegisterCubit>());
          }
          if (state.step == RegisterStep.verification &&
              state.status != RegisterStatus.failure) {
            sl<AppFeedbackService>().show(
              loc.authVerifySent,
              kind: AppFeedbackKind.success,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<RegisterCubit>();
          final loading = state.status == RegisterStatus.loading;

          if (state.step == RegisterStep.verification) {
            return AuthPageShell(
              title: loc.authVerifyTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(loc.authVerifyBody(state.email)),
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
                  const AuthFormGap(size: 24),
                  AuthPrimaryButton(
                    label: loc.authVerifyAction,
                    loading: loading,
                    onPressed: () {
                      cubit.submitVerificationCode(_codeController.text);
                    },
                  ),
                ],
              ),
            );
          }

          return AuthPageShell(
            title: loc.authRegisterTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(loc.authRegisterHint),
                const AuthFormGap(),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  onChanged: cubit.updateEmail,
                  decoration: InputDecoration(labelText: loc.authEmail),
                ),
                const AuthFormGap(),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  onChanged: cubit.updatePassword,
                  decoration: InputDecoration(
                    labelText: loc.authPassword,
                    helperText: loc.authPasswordHint,
                  ),
                ),
                const AuthFormGap(),
                TextField(
                  controller: _nickController,
                  autocorrect: false,
                  onChanged: cubit.updateNick,
                  decoration: InputDecoration(
                    labelText: loc.authNick,
                    helperText: loc.authNickHint,
                  ),
                ),
                _nickHelper(loc, state),
                const AuthFormGap(),
                TextField(
                  controller: _realNameController,
                  textCapitalization: TextCapitalization.words,
                  onChanged: cubit.updateRealName,
                  decoration: InputDecoration(labelText: loc.authRealName),
                ),
                const AuthFormGap(size: 24),
                AuthPrimaryButton(
                  label: loc.authRegisterAction,
                  loading: loading,
                  onPressed: () {
                    cubit
                      ..updateEmail(_emailController.text)
                      ..updatePassword(_passwordController.text)
                      ..updateNick(_nickController.text)
                      ..updateRealName(_realNameController.text)
                      ..submitCredentials();
                  },
                ),
                AuthLinkRow(
                  prompt: loc.authHaveAccount,
                  actionLabel: loc.authLoginAction,
                  onPressed: () => context.goToAuthLogin(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
