// ignore_for_file: library_private_types_in_public_api, avoid_renaming_method_parameters

import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/battle/widgets/fier_works.dart';
import 'package:expansion/ui/battle/widgets/modal.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/ui/widgets/messages.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 20));
  late BattleBloc bloc;
  int current = Get.find<UserRepository>().user.mapClassic - 1;

  @override
  void initState() {
    bloc = context.read<BattleBloc>();
    super.initState();
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
        bloc.add(PauseEvent());
        bool? result = await showModalBottom(
            context, YesNoModal(context, '${tr('exit_menu')}?'));
        if (result != null && result) {
          bloc.add(CloseEvent());
          router.pushReplacement('/');
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        bottomNavigationBar:
            (bloc.state.isWin || bloc.state.isLost || bloc.state.isBegin)
                ? Container(
                    height: bloc.state.isBegin ? 110.h : 145.h,
                    color: AppColor.darkBlue,
                    width: deviceSize.width,
                    child: bloc.state.isBegin
                        ? Column(
                            children: [
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                  context.locale != const Locale('ru')
                                      ? Get.find<GameRepository>()
                                          .scenes[current]
                                          .battleRu
                                      : Get.find<GameRepository>()
                                          .scenes[current]
                                          .battleEn,
                                  style: AppText.baseBody16),
                              SizedBox(height: 15.h),
                              ButtonLongSimple(
                                title: tr('started'),
                                function: () => bloc.add(EndBeginEvent()),
                              ),
                            ],
                          )
                        : WinLostModal(context),
                  )
                : const SizedBox.shrink(),
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
                  bloc: bloc,
                  listener: (context, state) async {
                    if (state.isWin) {
                      bloc.add(CloseEvent());
                      Future.delayed(const Duration(milliseconds: 800),
                          () async {
                        _confettiController.play();
                      });
                    }
                    if (state.isLost) bloc.add(CloseEvent());
                  },
                  builder: (context, state) {
                    return Stack(
                      children: [
                        ...state.bases.map((item) {
                          int index = state.bases.indexOf(item);
                          return item.build(
                            index: state.bases.indexOf(item),
                            context: context,
                            onAccept: (sender) =>
                                bloc.add(SendEvent(index, sender)),
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
                                    ? bloc.add(PlayEvent())
                                    : bloc.add(PauseEvent());
                              }),
                        ),
                        Positioned(
                          top: 10.h,
                          right: 30.w,
                          child: CircleButton(
                            iconPath: 'assets/svg/help.svg',
                            click: () {
                              bloc.add(PauseEvent());
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
                                bloc.add(PauseEvent());
                                bool? result = await showModalBottom(context,
                                    YesNoModal(context, '${tr('exit_menu')}?'));
                                if (result != null && result) {
                                  bloc.add(CloseEvent());
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
                                bloc.add(PauseEvent());
                                bool? result = await showModalBottom(context,
                                    YesNoModal(context, '${tr('replay')}?'));
                                if (result != null && result) {
                                  bloc.add(CloseEvent());
                                  await Future.delayed(
                                      const Duration(milliseconds: 200));
                                  router.pushReplacement('/battle');
                                  return;
                                }
                              }),
                        ),
                        if (state.isWin || state.isLost)
                          Positioned(
                            top: 40,
                            left: 26,
                            child: Column(
                              children: [
                                getTextInCard(state.isWin
                                    ? tr('win_text')
                                    : tr('lost_text')),
                                SizedBox(height: 30.h),
                                Container(
                                  width: deviceSize.width - 60,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: AppColor.darkYeloow),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
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
                                SizedBox(height: 30.h),
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
                          Positioned(
                            top: 250.h,
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
