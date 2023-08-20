// ignore_for_file: library_private_types_in_public_api, avoid_renaming_method_parameters

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/game/game.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/begin/bloc/begin_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/ui/widgets/line_buttons.dart';
import 'package:expansion/ui/widgets/messages.dart';
import 'package:expansion/ui/widgets/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BeginPage extends StatelessWidget {
  const BeginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<BeginBloc>();
    return Scaffold(
      bottomNavigationBar: Get.find<UserRepository>().user.isRegistration
          ? const SizedBox.shrink()
          : Container(
              color: AppColor.darkBlue,
              height: 150,
              width: deviceSize.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    tr("already_played"),
                    style: AppText.baseBody,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ButtonLongSimple(
                    title: tr('login'),
                    function: () {
                      router.go('/profile');
                    },
                  ),
                ],
              ),
            ),
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
                  LineMenu(tr('level'),
                      tr(Get.find<UserRepository>().game.level.name), () {
                    showModalBottom(
                      context,
                      ChooseLevel(context),
                    );
                  }),
                  SizedBox(
                    height: 40.h,
                  ),
                  LineMenu(
                      tr('hint'),
                      Get.find<UserRepository>().game.isHint
                          ? tr('turn2')
                          : tr('un_turn2'), () {
                    Get.find<UserRepository>().game = Get.find<UserRepository>()
                        .game
                        .copyWith(
                            isHint: !Get.find<UserRepository>().game.isHint);
                    context.read<BeginBloc>().add(ChangeHint());
                  }),
                  SizedBox(
                    height: 40.h,
                  ),
                  LineMenu(tr('universe'),
                      tr(Get.find<UserRepository>().game.univer.name), () {
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
                      Get.find<UserRepository>().user =
                          Get.find<UserRepository>()
                              .user
                              .copyWith(isBegin: false);
                      Get.find<UserRepository>().saveUser();
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
        for (var item in Univer.values) getUniver(item),
        helpGame(context2),
      ],
    );
  }

  Widget getUniver(Univer item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25.h),
      child: ButtonLong(
        title: tr(item.name),
        function: () {
          Navigator.of(context).pop();
          // context.read<BeginBloc>().add(ChangeUniver(item));
        },
      ),
    );
  }
}
