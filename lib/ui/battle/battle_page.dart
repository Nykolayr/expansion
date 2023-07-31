// ignore_for_file: library_private_types_in_public_api, avoid_renaming_method_parameters

import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/battle/widgets/fier_works.dart';
import 'package:expansion/ui/battle/widgets/modal.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/widgets/messages.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<BattleBloc>();
    return WillPopScope(
      onWillPop: () async {
        if (context.mounted) {
          context.read<BattleBloc>().add(PauseEvent());
        }
        bool? result = await showModalBottom(
            context, YesNoModal(context, '${tr('exit_menu')}?'));
        if (result != null && result) {
          if (context.mounted) {
            context.read<BattleBloc>().add(CloseEvent());
          }
          router.pushReplacement('/');
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Image.asset(
                'assets/images/fon2.png',
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: BlocConsumer<BattleBloc, BattleState>(
                  listener: (context, state) async {
                if (state.isWin) {
                  _confettiController.play();
                  Future.delayed(const Duration(seconds: 10), () {
                    showModalBottom(
                      context,
                      WinLostModal(context, true),
                    );
                  });
                }
                if (state.isLost) {
                  Future.delayed(const Duration(seconds: 10), () {
                    showModalBottom(
                      context,
                      WinLostModal(context, false),
                    );
                  });
                }
              }, builder: (context, state) {
                return Stack(
                  children: [
                    ...state.bases.map((item) {
                      int index = state.bases.indexOf(item);
                      return item.build(
                        index: state.bases.indexOf(item),
                        context: context,
                        onAccept: (sender) => context
                            .read<BattleBloc>()
                            .add(SendEvent(index, sender)),
                      );
                    }).toList(),
                    ...state.ships.map((item) {
                      return item.build(
                        index: item.index,
                        context: context,
                      );
                    }).toList(),
                    Positioned(
                      top: 10.h,
                      left: 30.w,
                      child: CircleButton(
                          iconPath: state.isPause
                              ? 'assets/svg/play.svg'
                              : 'assets/svg/pause.svg',
                          click: () {
                            if (state.isLost || state.isWin) return;
                            state.isPause
                                ? context.read<BattleBloc>().add(PlayEvent())
                                : context.read<BattleBloc>().add(PauseEvent());
                          }),
                    ),
                    Positioned(
                      top: 10.h,
                      right: 30.w,
                      child: CircleButton(
                        iconPath: 'assets/svg/help.svg',
                        click: () {
                          context.read<BattleBloc>().add(PauseEvent());
                          router.push('/help');
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 30.w,
                      child: CircleButton(
                          iconPath: 'assets/svg/exit.svg',
                          click: () async {
                            if (context.mounted) {
                              context.read<BattleBloc>().add(PauseEvent());
                            }
                            bool? result = await showModalBottom(context,
                                YesNoModal(context, '${tr('exit_menu')}?'));
                            if (result != null && result) {
                              if (context.mounted) {
                                context.read<BattleBloc>().add(CloseEvent());
                              }
                              router.pushReplacement('/');
                              return;
                            }
                          }),
                    ),
                    Positioned(
                      bottom: 10.h,
                      right: 30.w,
                      child: CircleButton(
                          iconPath: 'assets/svg/restart.svg',
                          click: () async {
                            if (context.mounted) {
                              context.read<BattleBloc>().add(PauseEvent());
                            }
                            bool? result = await showModalBottom(context,
                                YesNoModal(context, '${tr('replay')}?'));
                            if (result != null && result) {
                              if (context.mounted) {
                                context.read<BattleBloc>().add(CloseEvent());
                              }
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              router.pushReplacement('/battle');
                              return;
                            }
                          }),
                    ),
                    if (state.isWin || state.isLost)
                      Positioned(
                        top: 100,
                        left: 26,
                        child: Column(
                          children: [
                            getTextInCard(
                                state.isWin ? tr('win_text') : tr('lost_text')),
                            SizedBox(height: 50.h),
                            Container(
                              width: deviceSize.width - 60,
                              height: 300,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: AppColor.darkYeloow),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                  image: AssetImage(
                                    state.isWin
                                        ? 'assets/images/win.png'
                                        : 'assets/images/lost.png',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: 50.h),
                            getTextInCard(
                              state.isWin
                                  ? tr('win_score',
                                      args: [state.score.toString()])
                                  : tr('lost_score'),
                            ),
                          ],
                        ),
                      ),
                    if (state.isWin)
                      if (state.isWin)
                        Positioned(
                          top: 300.h,
                          left: deviceSize.width / 2,
                          child: Container(),
                        ),
                    Positioned(
                      top: 300.h,
                      left: deviceSize.width / 2,
                      child: FireworkScreen(
                        controllerCenter: _confettiController,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getTextInCard(text) {
  return Card(
    elevation: 10,
    color: AppColor.darkBlue,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: AppColor.darkYeloow, width: 2.w),
      borderRadius: BorderRadius.circular(10).r,
    ),
    child: Container(
      padding: const EdgeInsets.all(10),
      width: deviceSize.width - 62,
      child: Text(
        text,
        style: AppText.baseText.copyWith(color: AppColor.white),
      ),
    ),
  );
}
