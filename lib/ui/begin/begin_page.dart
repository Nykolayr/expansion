// ignore_for_file: library_private_types_in_public_api, avoid_renaming_method_parameters

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/game/game.dart';
import 'package:expansion/ui/begin/bloc/begin_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/ui/widgets/line_buttons.dart';
import 'package:expansion/ui/widgets/messages.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BeginPage extends StatelessWidget {
  const BeginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<BeginBloc>();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: deviceSize.height,
            child: Image.asset(
              'assets/images/fon1.png',
              fit: BoxFit.fill,
            ),
          ),
          BlocConsumer<BeginBloc, BeginState>(
              listener: (context, state) async {},
              builder: (context, state) {
                return Container(
                  width: deviceSize.width,
                  padding: const EdgeInsets.symmetric(
                    vertical: 75,
                    horizontal: 45,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          tr("new_game"),
                          style: AppText.baseText.copyWith(
                            fontSize: 30.sp,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      LineMenu(tr('level'), tr(userRepository.game.level.name),
                          () {
                        showModalBottom(
                          context,
                          ChooseLevel(context),
                        );
                      }),
                      const SizedBox(
                        height: 40,
                      ),
                      LineMenu(
                          tr('hint'),
                          userRepository.game.isHint
                              ? tr('turn2')
                              : tr('un_turn2'), () {
                        userRepository.game = userRepository.game
                            .copyWith(isHint: !userRepository.game.isHint);
                        context.read<BeginBloc>().add(ChangeHint());
                      }),
                      const SizedBox(
                        height: 40,
                      ),
                      LineMenu(
                          tr('universe'), tr(userRepository.game.univer.name),
                          () {
                        showModalBottom(
                          context,
                          ChooseUniver(context),
                        );
                      }),
                      const SizedBox(
                        height: 70,
                      ),
                      ButtonLong(
                        title: tr('save_humanity'),
                        function: () => context.go('/battle'),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class ChooseLevel extends StatelessWidget {
  final BuildContext context;
  const ChooseLevel(this.context, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context2) {
    return Column(
      children: [
        Text(
          tr('choose_level'),
          style: AppText.baseTitle,
        ),
        const SizedBox(
          height: 25,
        ),
        ButtonLong(
          title: Level.easy.nameMenu,
          function: () {
            Navigator.of(context).pop();
            context.read<BeginBloc>().add(const ChangeLevel(Level.easy));
          },
        ),
        const SizedBox(
          height: 25,
        ),
        ButtonLong(
          title: Level.average.nameMenu,
          function: () {
            Navigator.of(context).pop();
            context.read<BeginBloc>().add(const ChangeLevel(Level.average));
          },
        ),
        const SizedBox(
          height: 25,
        ),
        ButtonLong(
          title: Level.difficult.nameMenu,
          function: () {
            Navigator.of(context).pop();
            context.read<BeginBloc>().add(const ChangeLevel(Level.difficult));
          },
        ),
      ],
    );
  }
}

class ChooseUniver extends StatelessWidget {
  final BuildContext context;
  const ChooseUniver(this.context, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context2) {
    return Column(
      children: [
        Text(
          tr('choose_univer'),
          style: AppText.baseTitle,
        ),
        const SizedBox(
          height: 25,
        ),
        ButtonLong(
          title: tr(Univer.classic.name),
          function: () {
            Navigator.of(context).pop();
            context.read<BeginBloc>().add(const ChangeUniver(Univer.classic));
          },
        ),
        const SizedBox(
          height: 25,
        ),
        ButtonLong(
          title: tr(Univer.generated.name),
          function: () {
            Navigator.of(context).pop();
            context.read<BeginBloc>().add(const ChangeUniver(Univer.generated));
          },
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
