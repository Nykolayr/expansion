import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_cubit.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_state.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/splash/splash_cubit.dart';
import 'package:expansion/presentation/bloc/splash/splash_state.dart';
import 'package:expansion/presentation/widgets/splash/splash_line_buttons.dart';
import 'package:expansion/presentation/widgets/splash/splash_loader_panel.dart';
import 'package:expansion/presentation/widgets/splash/splash_long_button.dart';
import 'package:expansion/presentation/widgets/splash/splash_menu_direct.dart';

/// Стартовый экран игры (legacy `SplashPage`).
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// Галочка «Не показывать при следующей загрузке» — по умолчанию включена.
  bool _dontShowIntroOnNextLoad = true;
  bool _splashLoadStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_splashLoadStarted) return;
    _splashLoadStarted = true;

    final cubit = sl<SplashCubit>();
    if (!cubit.state.isSuccess) {
      final introLength = AppLocalizations.of(context)!.splashPretext.length;
      cubit.start(introTextLength: introLength);
    }
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

  Future<void> _onContinue() async {
    final guest = await sl<GuestProfileRepository>().load();
    if (!mounted) return;
    if (guest.firstBattleCompleted) {
      context.goToMaps();
    } else {
      context.goToBegin();
    }
  }

  void _onIntroFinished(SplashState state) {
    if (!state.showIntro) return;
    sl<SplashCubit>().applyIntroPreference(
      dontShowOnNextLoad: _dontShowIntroOnNextLoad,
    );
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
          final showIntroControls = state.showIntro && !state.isSuccess;
          final showLoader = !state.isSuccess;

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                GameAssets.splashBackground,
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
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
                        footer: showIntroControls
                            ? Material(
                                color: ExpansionColors.background
                                    .withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(8),
                                child: CheckboxListTile(
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  value: _dontShowIntroOnNextLoad,
                                  onChanged: (value) {
                                    setState(() {
                                      _dontShowIntroOnNextLoad = value ?? true;
                                    });
                                  },
                                  activeColor: ExpansionColors.accent,
                                  checkColor: ExpansionColors.black,
                                  title: Text(
                                    loc.splashDontShowAgain,
                                    style: ExpansionTextStyles.bodyOnDark(
                                      context,
                                      13,
                                    ),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 0,
                                  ),
                                ),
                              )
                            : null,
                      )
                    : const SizedBox.shrink(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(seconds: 2),
                  height: state.isSuccess ? menuSlotHeight + 40 : 0,
                  width: size.width,
                  child: state.isSuccess
                      ? (state.showIntro
                          ? SplashLongButton(
                              title: loc.splashBeginGame,
                              onPressed: _onBeginGame,
                            )
                          : SplashLineButtons(
                              isTop: false,
                              onMenuTap: _onMenuTap,
                            ))
                      : const SizedBox.shrink(),
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
