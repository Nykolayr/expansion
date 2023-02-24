// ignore_for_file: library_private_types_in_public_api, avoid_renaming_method_parameters

import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> accepted = [];
    List<dynamic> rejected = [];

    context.watch<BattleBloc>();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: deviceSize.height,
            child: Image.asset(
              'assets/images/fon2.png',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: BlocConsumer<BattleBloc, BattleState>(
                listener: (context, state) async {},
                builder: (context, state) {
                  if (state is BattleChange) {
                    return Stack(
                      children: [
                        ...state.objects.map((item) {
                          int index = state.objects.indexOf(item);
                          return item.build(
                              state.index == index,
                              () => context
                                  .read<BattleBloc>()
                                  .add(PressEvent(index)));
                        }).toList(),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            color: Colors.yellow,
                            child: Center(
                              child: (state.index == -1)
                                  ? const Text(
                                      'Выберите объект на карте, чтобы узнать подробности')
                                  : state.objects[state.index].getText(),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   child: DragTarget<String>(
                        //     builder: (
                        //       BuildContext context,
                        //       List<dynamic> accepted,
                        //       List<dynamic> rejected,
                        //     ) {
                        //       return Container(
                        //         height: 300,
                        //         width: 300,
                        //         color: Colors.black,
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
          ),
        ],
      ),
    );
  }
}
