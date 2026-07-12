import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/profile/profile_cubit.dart';
import 'package:expansion/presentation/bloc/profile/profile_state.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_compact_skew_button.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/cards/game_stat_card.dart';
import 'package:expansion/presentation/widgets/dialogs/game_confirm_dialog.dart';
import 'package:expansion/presentation/widgets/layout/game_sticky_bottom_bar.dart';

class _CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final formatted = text[0].toUpperCase() +
        (text.length > 1 ? text.substring(1) : '');
    if (formatted == text) return newValue;

    return newValue.copyWith(
      text: formatted,
      composing: TextRange.empty,
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();
  String _savedName = '';

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
    sl<ProfileCubit>().load();
  }

  @override
  void activate() {
    super.activate();
    sl<ProfileCubit>().load();
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showGameConfirmDialog(
      context,
      title: loc.profileDeleteAccountTitle,
      message: loc.profileDeleteAccountBody,
      confirmLabel: loc.profileDeleteAccountConfirm,
      cancelLabel: loc.beginResetCancel,
    );

    if (confirmed != true || !context.mounted) return;

    final ok = await sl<ProfileCubit>().deleteAccount();
    if (!context.mounted) return;

    if (ok) {
      sl<AppFeedbackService>().show(
        loc.profileDeleteAccountSuccess,
        kind: AppFeedbackKind.success,
      );
    } else {
      sl<AppFeedbackService>().show(loc.authErrorGeneric);
    }
  }

  Future<void> _logout(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final ok = await sl<ProfileCubit>().logout();
    if (!context.mounted) return;

    if (ok) {
      sl<AppFeedbackService>().show(
        loc.profileLogoutSuccess,
        kind: AppFeedbackKind.success,
      );
    } else {
      sl<AppFeedbackService>().show(loc.authErrorGeneric);
    }
  }

  Widget _accountInfoSection(BuildContext context, ProfileState state) {
    final loc = AppLocalizations.of(context)!;

    if (state.accountLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isLoggedIn) {
      final user = state.accountUser!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.profileAccountTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(8),
          GameStatCard(title: loc.authNick, value: user.nick),
          const Gap(12),
          GameStatCard(title: loc.authEmail, value: user.email),
        ],
      );
    }

    return Text(
      loc.profileAccountHint,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _bottomActions(BuildContext context, ProfileState state) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: GameLongButton(
            label: loc.profileSave,
            fontSize: 16,
            onPressed: _canSave ? _saveName : null,
          ),
        ),
        if (state.isLoggedIn) ...[
          const Gap(8),
          Center(
            child: GameLongButton(
              label: loc.profileLogout,
              fontSize: 16,
              onPressed: () => _logout(context),
            ),
          ),
          const Gap(8),
          Center(
            child: GameCompactSkewButton(
              label: loc.profileDeleteAccount,
              fullWidth: true,
              fontSize: 15,
              labelColor: ExpansionColors.red,
              onPressed: () => _confirmDeleteAccount(context),
            ),
          ),
        ] else if (!state.accountLoading) ...[
          const Gap(8),
          Center(
            child: GameLongButton(
              label: loc.profileRegister,
              onPressed: () => context.goToAuthRegister(),
            ),
          ),
          const Gap(8),
          Center(
            child: GameLongButton(
              label: loc.profileLogin,
              fontSize: 16,
              onPressed: () => context.goToAuthLogin(),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameFocus.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() => setState(() {});

  bool get _canSave {
    final trimmed = _nameController.text.trim();
    return trimmed.isNotEmpty && trimmed != _savedName;
  }

  Future<void> _saveName() async {
    if (!_canSave) return;
    await sl<ProfileCubit>().updateDisplayName(_nameController.text);
    if (!mounted) return;
    setState(() => _savedName = _nameController.text.trim());
    _nameFocus.unfocus();
  }

  String _displayName(AppLocalizations loc, ProfileState state) {
    final name = state.profile?.displayName ?? '';
    if (name.trim().isEmpty) return loc.profileGuestLabel;
    return name.trim();
  }

  String _startedLabel(ProfileState state, AppLocalizations loc) {
    final ms = state.profile?.campaignStartedAtMillis ?? 0;
    if (ms <= 0) return '—';
    final date = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .format(date);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.splashBackground, fit: BoxFit.cover),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameScreenBackBar(title: loc.profileTitle),
              Expanded(
                child: BlocConsumer<ProfileCubit, ProfileState>(
                  bloc: sl<ProfileCubit>(),
                  listenWhen: (p, c) =>
                      p.profile?.displayName != c.profile?.displayName,
                  listener: (context, state) {
                    final name = state.profile?.displayName ?? '';
                    if (_nameController.text != name) {
                      _nameController.text = name;
                    }
                    _savedName = name.trim();
                  },
                  builder: (context, state) {
                    if (state.status == ProfileStatus.loading ||
                        state.status == ProfileStatus.initial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == ProfileStatus.failure ||
                        state.profile == null) {
                      return Center(child: Text(loc.mapsLoadFailed));
                    }

                    final profile = state.profile!;
                    if (_savedName.isEmpty && profile.displayName.isNotEmpty) {
                      _savedName = profile.displayName.trim();
                    }
                    if (_nameController.text.isEmpty &&
                        profile.displayName.isNotEmpty) {
                      _nameController.text = profile.displayName;
                    }

                    return Stack(
                      children: [
                        ListView(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            24,
                            24,
                            GameStickyBottomBar.scrollPadding(context),
                          ),
                          children: [
                            Text(
                              _displayName(loc, state),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const Gap(16),
                            TextField(
                              controller: _nameController,
                              focusNode: _nameFocus,
                              inputFormatters: [
                                _CapitalizeFirstLetterFormatter(),
                              ],
                              decoration: InputDecoration(
                                labelText: loc.profileDisplayName,
                                hintText: loc.profileDisplayNameHint,
                              ),
                            ),
                            const Gap(16),
                            GameStatCard(
                              title: loc.profileMission,
                              value: '${profile.mapClassic} / 40',
                            ),
                            const Gap(12),
                            GameStatCard(
                              title: loc.profileScore,
                              value: '${profile.scoreClassic}',
                            ),
                            const Gap(12),
                            GameStatCard(
                              title: loc.profileStarted,
                              value: _startedLabel(state, loc),
                            ),
                            const Gap(24),
                            _accountInfoSection(context, state),
                          ],
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: GameStickyBottomBar(
                            child: _bottomActions(context, state),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
