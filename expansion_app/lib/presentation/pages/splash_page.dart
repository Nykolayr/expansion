import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_cubit.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_state.dart';
import 'package:expansion/presentation/bloc/splash/splash_cubit.dart';
import 'package:expansion/presentation/bloc/splash/splash_state.dart';
import 'package:expansion/presentation/widgets/splash/new_missions_banner.dart';
import 'package:expansion/presentation/widgets/splash/splash_intro_overlay.dart';
import 'package:expansion/presentation/widgets/splash/splash_line_buttons.dart';
import 'package:expansion/presentation/widgets/splash/splash_loader_panel.dart';
import 'package:expansion/presentation/widgets/splash/splash_long_button.dart';
import 'package:expansion/presentation/widgets/splash/splash_menu_direct.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';

/// Стартовый экран игры (legacy `SplashPage`).
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _splashStartScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleSplashStart();
  }

  void _scheduleSplashStart() {
    final cubit = sl<SplashCubit>();
    if (cubit.state.isSuccess) {
      _splashStartScheduled = false;
      cubit.refreshMenuProgress();
      return;
    }
    if (_splashStartScheduled) return;
    _splashStartScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final c = sl<SplashCubit>();
      if (c.state.isSuccess) {
        _splashStartScheduled = false;
        return;
      }
      final introLength = AppLocalizations.of(context)!.splashPretext.length;
      c.start(introTextLength: introLength);
    });
  }

  void _onMenuTap(SplashMenuDirect direct) {
    AppLog.trace('splash menu tap: $direct', tag: 'Splash');
    switch (direct) {
      case SplashMenuDirect.leftTop:
        context.goToProfile();
      case SplashMenuDirect.middleTop:
        context.goToSettings();
      case SplashMenuDirect.rightTop:
        context.goToProgress();
      case SplashMenuDirect.leftBottom:
        context.goToBegin();
      case SplashMenuDirect.rightBottom:
        _onContinue();
      case SplashMenuDirect.middleBottom:
        context.goToUpgrades();
    }
  }

  void _onBeginGame() {
    context.goToBegin();
  }

  void _onContinue() {
    if (!sl<SplashCubit>().state.canContinue) return;
    context.goToMaps();
  }

  void _onIntroFinished(SplashState state) {
    sl<SplashCubit>().markIntroSeen();
  }

  void _onSkipIntro() {
    sl<SplashCubit>().skipIntro();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final menuSlotHeight = size.width / 3 / 3 + 10;

    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashState>(
          bloc: sl<SplashCubit>(),
          listenWhen: (previous, current) =>
              !previous.isSuccess && current.isSuccess,
          listener: (context, state) => _onIntroFinished(state),
        ),
        BlocListener<AppBootstrapCubit, AppBootstrapState>(
          bloc: sl<AppBootstrapCubit>(),
          listenWhen: (previous, current) =>
              previous.status != AppBootstrapStatus.failed &&
              current.status == AppBootstrapStatus.failed,
          listener: (context, state) {
            sl<AppFeedbackService>().show(
              AppLocalizations.of(context)!.bootstrapInitFailed,
              kind: AppFeedbackKind.error,
            );
          },
        ),
      ],
      child: BlocBuilder<SplashCubit, SplashState>(
        bloc: sl<SplashCubit>(),
        builder: (context, state) {
          final showLoader = !state.isSuccess;
          final showBigNewGame = state.isSuccess && !state.canContinue;
          final showBottomMenuRow = state.isSuccess && state.canContinue;

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              GameMenuBackdrop(fit: BoxFit.fill),
              GameMenuTheme(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
              Center(
                child: Column(
                  children: [
                    const Gap(20),
                    AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(seconds: 2),
                      height: state.isSuccess ? menuSlotHeight + 40 : 0,
                      child: state.isSuccess
                          ? SplashLineButtons(
                              isTop: true,
                              onMenuTap: _onMenuTap,
                              continueEnabled: state.canContinue,
                            )
                          : const SizedBox.shrink(),
                    ),
                    AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(seconds: 2),
                      height: state.isSuccess ? 0 : menuSlotHeight + 40,
                    ),
                    const Gap(20),
                    Text(
                      loc.splashTitleSpace,
                      style: ExpansionTextStyles.titleAccent(context, 42),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(10),
                    Text(
                      loc.splashTitleExpansion,
                      style: ExpansionTextStyles.titleAccent(context, 52),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: showLoader
                    ? SplashLoaderPanel(
                        state: state,
                      )
                    : const SizedBox.shrink(),
              ),
              if (showLoader && state.showIntro)
                SplashIntroOverlay(
                  onSkip: _onSkipIntro,
                ),
              BlocBuilder<AppBootstrapCubit, AppBootstrapState>(
                bloc: sl<AppBootstrapCubit>(),
                builder: (context, bootstrap) {
                  if (!state.isSuccess || !bootstrap.showNewMissionsBanner) {
                    return const SizedBox.shrink();
                  }
                  return Align(
                    alignment: Alignment.topCenter,
                    child: NewMissionsBanner(
                      onOpenMaps: () {
                        sl<AppBootstrapCubit>().acknowledgeNewMissions();
                        context.goToMaps();
                      },
                      onDismiss: () {
                        sl<AppBootstrapCubit>().acknowledgeNewMissions();
                      },
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(seconds: 2),
                  height: state.isSuccess ? menuSlotHeight + 40 : 0,
                  width: size.width,
                  child: state.isSuccess
                      ? (showBigNewGame
                          ? SplashLongButton(
                              title: loc.splashMenuNewGame,
                              onPressed: _onBeginGame,
                            )
                          : showBottomMenuRow
                              ? SplashLineButtons(
                                  isTop: false,
                                  onMenuTap: _onMenuTap,
                                  continueEnabled: true,
                                )
                              : const SizedBox.shrink())
                      : const SizedBox.shrink(),
                ),
              ),
                  ],
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
