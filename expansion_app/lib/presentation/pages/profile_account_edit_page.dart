import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/auth/register_state.dart';
import 'package:expansion/presentation/bloc/profile/account_edit_cubit.dart';
import 'package:expansion/presentation/bloc/profile/account_edit_state.dart';
import 'package:expansion/presentation/bloc/profile/profile_cubit.dart';
import 'package:expansion/presentation/widgets/auth/auth_messages.dart';
import 'package:expansion/presentation/widgets/auth/auth_page_shell.dart';
import 'package:expansion/presentation/widgets/forms/game_password_field.dart';

class ProfileAccountEditPage extends StatefulWidget {
  const ProfileAccountEditPage({
    required this.initialRealName,
    required this.initialNick,
    required this.initialEmail,
    super.key,
  });

  final String initialRealName;
  final String initialNick;
  final String initialEmail;

  @override
  State<ProfileAccountEditPage> createState() => _ProfileAccountEditPageState();
}

class _ProfileAccountEditPageState extends State<ProfileAccountEditPage> {
  late final TextEditingController _realNameController;
  late final TextEditingController _nickController;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;

  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _realNameController = TextEditingController(text: widget.initialRealName);
    _nickController = TextEditingController(text: widget.initialNick);
    _emailController = TextEditingController(text: widget.initialEmail);
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _realNameController.dispose();
    _nickController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Widget _nickHelper(AppLocalizations loc, AccountEditState state) {
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

  Future<void> _onSuccess(
    BuildContext context,
    AccountEditCubit cubit,
    AccountEditState state,
  ) async {
    final loc = AppLocalizations.of(context)!;
    await sl<ProfileCubit>().load();

    if (!context.mounted) return;

    if (state.passwordChanged) {
      await sl<ProfileCubit>().logout();
      if (!context.mounted) return;
      sl<AppFeedbackService>().show(
        loc.profilePasswordChangedRelogin,
        kind: AppFeedbackKind.success,
      );
      context.pop();
      return;
    }

    sl<AppFeedbackService>().show(
      loc.profileAccountSaved,
      kind: AppFeedbackKind.success,
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => AccountEditCubit(
        sl(),
        sl(),
        sl(),
        initialNick: widget.initialNick,
      ),
      child: BlocConsumer<AccountEditCubit, AccountEditState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == AccountEditStatus.failure) {
            sl<AppFeedbackService>().show(
              resolveAuthMessage(loc, state.errorMessage),
            );
          }
          if (state.status == AccountEditStatus.success) {
            _onSuccess(context, context.read<AccountEditCubit>(), state);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AccountEditCubit>();
          final loading = state.status == AccountEditStatus.loading;
          final changingPassword = _newPasswordController.text.isNotEmpty;

          return AuthPageShell(
            title: loc.profileAccountEditTitle,
            bottomBar: AuthPrimaryButton(
              label: loc.profileSave,
              loading: loading,
              onPressed: state.nickStatus == NickCheckStatus.unavailable ||
                      state.nickStatus == NickCheckStatus.checking
                  ? null
                  : () {
                      cubit.submit(
                        realName: _realNameController.text,
                        nick: _nickController.text,
                        currentPassword: _currentPasswordController.text,
                        newPassword: _newPasswordController.text,
                      );
                    },
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(loc.profileAccountEditHint),
                const AuthFormGap(),
                TextField(
                  controller: _realNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: loc.authRealName),
                ),
                const AuthFormGap(),
                TextField(
                  controller: _nickController,
                  autocorrect: false,
                  onChanged: cubit.checkNick,
                  decoration: InputDecoration(
                    labelText: loc.authNick,
                    helperText: loc.authNickHint,
                  ),
                ),
                _nickHelper(loc, state),
                const AuthFormGap(),
                TextField(
                  readOnly: true,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: loc.authEmail,
                    helperText: loc.profileEmailReadonlyHint,
                  ),
                ),
                const AuthFormGap(size: 24),
                Text(
                  loc.profileChangePasswordSection,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const AuthFormGap(size: 8),
                Text(
                  loc.profileChangePasswordHint,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const AuthFormGap(),
                GamePasswordField(
                  controller: _currentPasswordController,
                  labelText: loc.profileCurrentPassword,
                ),
                const AuthFormGap(),
                GamePasswordField(
                  controller: _newPasswordController,
                  onChanged: (_) => setState(() {}),
                  labelText: loc.profileNewPassword,
                  helperText: loc.authPasswordHint,
                ),
                if (changingPassword) ...[
                  const AuthFormGap(size: 8),
                  Text(
                    loc.profileCurrentPasswordRequired,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
