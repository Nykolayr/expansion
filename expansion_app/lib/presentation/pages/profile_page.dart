import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/constants/game_database_constants.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/profile/profile_cubit.dart';
import 'package:expansion/presentation/bloc/profile/profile_state.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/cards/game_stat_card.dart';
import 'package:expansion/presentation/widgets/dialogs/game_confirm_dialog.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';
import 'package:expansion/presentation/widgets/layout/game_sticky_bottom_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
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

  Widget _accountHeader(BuildContext context, ProfileState state) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Text(
            loc.profileAccountTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (state.isLoggedIn)
          IconButton(
            tooltip: loc.profileAccountEditTitle,
            icon: const Icon(Icons.edit_outlined, color: ExpansionColors.accent),
            onPressed: () {
              final user = state.accountUser!;
              context.goToProfileAccountEdit(
                realName: user.realName,
                nick: user.nick,
                email: user.email,
              );
            },
          ),
      ],
    );
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
          _accountHeader(context, state),
          const Gap(8),
          GameStatCard(title: loc.authRealName, value: user.realName),
          const Gap(12),
          GameStatCard(title: loc.authNick, value: user.nick),
          const Gap(12),
          GameStatCard(title: loc.authEmail, value: user.email),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          loc.profileAccountTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(8),
        Text(
          loc.profileAccountHint,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _bottomActions(BuildContext context, ProfileState state) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state.isLoggedIn) ...[
          GameLongButton(
            label: loc.profileLogout,
            fontSize: 16,
            onPressed: () => _logout(context),
          ),
          const Gap(8),
          GameLongButton(
            label: loc.profileDeleteAccount,
            fontSize: 16,
            labelColor: ExpansionColors.red,
            onPressed: () => _confirmDeleteAccount(context),
          ),
        ] else if (!state.accountLoading) ...[
          GameLongButton(
            label: loc.profileRegister,
            onPressed: () => context.goToAuthRegister(),
          ),
          const Gap(8),
          GameLongButton(
            label: loc.profileLogin,
            fontSize: 16,
            onPressed: () => context.goToAuthLogin(),
          ),
        ],
      ],
    );
  }

  String _headlineName(AppLocalizations loc, ProfileState state) {
    if (state.isLoggedIn) {
      final realName = state.accountUser?.realName.trim() ?? '';
      if (realName.isNotEmpty) return realName;
    }

    final display = state.profile?.displayName.trim() ?? '';
    if (display.isNotEmpty) return display;

    return loc.profileGuestLabel;
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
          const GameMenuBackdrop(),
          GameMenuTheme(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GameScreenBackBar(title: loc.profileTitle),
                Expanded(
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                  bloc: sl<ProfileCubit>(),
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
                              _headlineName(loc, state),
                              style:
                                  Theme.of(context).textTheme.headlineSmall,
                            ),
                            const Gap(24),
                            GameStatCard(
                              title: loc.profileMission,
                              value:
                                  '${profile.mapClassic} / ${GameDatabaseConstants.campaignMissionCount}',
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
          ),
        ],
      ),
    );
  }
}
