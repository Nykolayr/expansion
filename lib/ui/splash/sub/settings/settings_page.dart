// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/setting/settings.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/ui/widgets/line_buttons.dart';
import 'package:expansion/ui/widgets/messages.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'bloc/setting_bloc.dart';

UserRepository userRepository = Get.find<UserRepository>();

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<SettingBloc>();
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
          appButtonBack(tr("settings")),
          BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
            return Container(
              width: deviceSize.width,
              padding: const EdgeInsets.symmetric(
                vertical: 75,
                horizontal: 45,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 70.h,
                  ),
                  LineMenu(
                      tr('music'),
                      userRepository.settings.isMusic
                          ? tr('turn')
                          : tr('un_turn'), () {
                    userRepository.settings = userRepository.settings
                        .copyWith(isMusic: !userRepository.settings.isMusic);
                    context.read<SettingBloc>().add(ChangeSound());
                  }),
                  SizedBox(
                    height: 40.h,
                  ),
                  LineMenu(
                      tr('sound'),
                      userRepository.settings.isSound
                          ? tr('turn2')
                          : tr('un_turn2'), () {
                    userRepository.settings = userRepository.settings
                        .copyWith(isSound: !userRepository.settings.isSound);
                    context.read<SettingBloc>().add(ChangeSound());
                  }),
                  SizedBox(
                    height: 40.h,
                  ),
                  LineMenu(tr('lang'), userRepository.settings.lang.nameMenu,
                      () {
                    showModalBottom(
                      context,
                      ChooseLang(context),
                    );
                  }),
                  SizedBox(
                    height: 40.h,
                  ),
                  ButtonLong(
                    title: tr('politica'),
                    function: () => showPolitic(context),
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

class ChooseLang extends StatelessWidget {
  final BuildContext context;
  const ChooseLang(this.context, {Key? key}) : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext context2) {
    return Column(
      children: [
        Text(
          tr('choose_lang'),
          style: AppText.baseTitle,
        ),
        SizedBox(
          height: 25.h,
        ),
        ButtonLong(
          title: userRepository.settings.lang.nameSelectRu,
          function: () {
            Navigator.of(context).pop();
            context.setLocale(Lang.ru.locale);
            context.read<SettingBloc>().add(const ChangeLang(Lang.ru));
          },
        ),
        SizedBox(
          height: 25.h,
        ),
        ButtonLong(
          title: userRepository.settings.lang.nameSelectEng,
          function: () {
            Navigator.of(context).pop();
            context.setLocale(Lang.en.locale);
            context.read<SettingBloc>().add(const ChangeLang(Lang.en));
          },
        ),
      ],
    );
  }
}
