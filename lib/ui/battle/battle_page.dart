// ignore_for_file: library_private_types_in_public_api, avoid_renaming_method_parameters

import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        ...state.objects.map((item) => item.build()).toList()
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
