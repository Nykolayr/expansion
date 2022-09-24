// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/user/setting/settings.dart';
import 'package:expansion/ui/widgets/line_buttons.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/setting_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<SettingBloc>();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/fon1.png',
              fit: BoxFit.fill,
            ),
          ),
          BlocConsumer<SettingBloc, SettingState>(
              listener: (context, state) async {},
              builder: (context, state) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    vertical: 75,
                    horizontal: 45,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          tr("settings"),
                          style: AppText.baseText.copyWith(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      LineMenu(
                          tr('music'),
                          userRepository.settings.isMusic
                              ? tr('turn')
                              : tr('un_turn'), () {
                        userRepository.settings = userRepository.settings
                            .copyWith(
                                isMusic: !userRepository.settings.isMusic);
                        context.read<SettingBloc>().add(ChangeSound());
                      }),
                      const SizedBox(
                        height: 40,
                      ),
                      LineMenu(
                          tr('sound'),
                          userRepository.settings.isSound
                              ? tr('turn2')
                              : tr('un_turn2'), () {
                        userRepository.settings = userRepository.settings
                            .copyWith(
                                isSound: !userRepository.settings.isSound);
                        context.read<SettingBloc>().add(ChangeSound());
                      }),
                      const SizedBox(
                        height: 40,
                      ),
                      LineMenu(tr('lang'),
                          userRepository.settings.lang.nameMenu, () {}),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
