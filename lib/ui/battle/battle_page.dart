// ignore_for_file: library_private_types_in_public_api, avoid_renaming_method_parameters

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/battle/widgets/modal.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/widgets/messages.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({Key? key}) : super(key: key);
// PageRouter().routeToUntil(context, LoginScreen());
  @override
  Widget build(BuildContext context) {
    context.watch<BattleBloc>();
    return WillPopScope(
      onWillPop: () async {
        bool? result = await showModalBottom(
            context, YesNoModal(context, tr('quit_game')));
        if (result!) {
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
                  Future.delayed(const Duration(seconds: 2), () {
                    showModalBottom(
                      context,
                      WinLostModal(context, true),
                    );
                  });
                }
                if (state.isLost) {
                  if (state.isWin) {
                    Future.delayed(const Duration(seconds: 2), () {
                      showModalBottom(
                        context,
                        WinLostModal(context, false),
                      );
                    });
                  }
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
                      top: 10,
                      left: 30,
                      child: CircleButton(
                        iconPath: state.isPause
                            ? 'assets/svg/play.svg'
                            : 'assets/svg/pause.svg',
                        click: () => state.isPause
                            ? context.read<BattleBloc>().add(PauseEvent())
                            : context.read<BattleBloc>().add(PlayEvent()),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 30,
                      child: CircleButton(
                        iconPath: 'assets/svg/help.svg',
                        click: () => router.push('/help'),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 30,
                      child: CircleButton(
                          iconPath: 'assets/svg/exit.svg',
                          click: () async {
                            context.read<BattleBloc>().add(PlayEvent());
                            bool? result = await showModalBottom(context,
                                YesNoModal(context, '${tr('exit_menu')}?'));
                            if (result!) {
                              if (context.mounted) {
                                context.read<BattleBloc>().add(CloseEvent());
                              }
                              router.pushReplacement('/');
                              return;
                            }
                            if (context.mounted) {
                              context.read<BattleBloc>().add(PauseEvent());
                            }
                          }),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 30,
                      child: CircleButton(
                          iconPath: 'assets/svg/restart.svg',
                          click: () async {
                            context.read<BattleBloc>().add(PlayEvent());
                            bool? result = await showModalBottom(context,
                                YesNoModal(context, '${tr('replay')}?'));
                            if (result!) {
                              print('object');
                              if (context.mounted) {
                                context.read<BattleBloc>().add(CloseEvent());
                              }
                              await Future.delayed(
                                  const Duration(milliseconds: 15000));
                              router.pushReplacement('/new_game');
                              return;
                            }
                            if (context.mounted) {
                              context.read<BattleBloc>().add(PauseEvent());
                            }
                          }),
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
