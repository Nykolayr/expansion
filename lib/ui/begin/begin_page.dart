// ignore_for_file: library_private_types_in_public_api, avoid_renaming_method_parameters

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/game/game.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/begin/bloc/begin_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/ui/widgets/line_buttons.dart';
import 'package:expansion/ui/widgets/messages.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          appButtonBack(tr("new_game")),
          BlocBuilder<BeginBloc, BeginState>(builder: (context, state) {
            return Container(
              width: deviceSize.width,
              padding: EdgeInsets.symmetric(
                vertical: 75.h,
                horizontal: 45.w,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 70.h,
                  ),
                  LineMenu(tr('level'), tr(userRepository.game.level.name), () {
                    showModalBottom(
                      context,
                      ChooseLevel(context),
                    );
                  }),
                  SizedBox(
                    height: 40.h,
                  ),
                  LineMenu(tr('hint'),
                      userRepository.game.isHint ? tr('turn2') : tr('un_turn2'),
                      () {
                    userRepository.game = userRepository.game
                        .copyWith(isHint: !userRepository.game.isHint);
                    context.read<BeginBloc>().add(ChangeHint());
                  }),
                  SizedBox(
                    height: 40.h,
                  ),
                  LineMenu(tr('universe'), tr(userRepository.game.univer.name),
                      () {
                    showModalBottom(
                      context,
                      ChooseUniver(context),
                    );
                  }),
                  SizedBox(
                    height: 70.h,
                  ),
                  ButtonLong(
                    title: tr('save_humanity'),
                    function: () {
                      userRepository.user =
                          userRepository.user.copyWith(isBegin: false);
                      userRepository.saveUser();
                      router.go('/battle');
                    },
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
        SizedBox(
          height: 25.h,
        ),
        ButtonLong(
          title: Level.easy.nameMenu,
          function: () {
            Navigator.of(context).pop();
            context.read<BeginBloc>().add(const ChangeLevel(Level.easy));
          },
        ),
        SizedBox(
          height: 25.h,
        ),
        ButtonLong(
          title: Level.average.nameMenu,
          function: () {
            Navigator.of(context).pop();
            context.read<BeginBloc>().add(const ChangeLevel(Level.average));
          },
        ),
        SizedBox(
          height: 25.h,
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
        SizedBox(
          height: 25.h,
        ),
        ButtonLong(
          title: tr(Univer.classic.name),
          function: () {
            Navigator.of(context).pop();
            context.read<BeginBloc>().add(const ChangeUniver(Univer.classic));
          },
        ),
        SizedBox(
          height: 25.h,
        ),
        ButtonLong(
          title: tr(Univer.generated.name),
          function: () {
            Navigator.of(context).pop();
            context.read<BeginBloc>().add(const ChangeUniver(Univer.generated));
          },
        ),
        SizedBox(
          height: 25.h,
        ),
      ],
    );
  }
}
