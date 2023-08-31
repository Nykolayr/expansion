import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WinLostModal extends StatelessWidget {
  final BuildContext context;
  const WinLostModal(this.context, {super.key});

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext context2) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        // Text(
        //   tr('next_step'),
        //   style: AppText.baseTitle,
        // ),
        // SizedBox(
        //   height: 25.h,
        // ),
        if (context.read<BattleBloc>().state.isWin)
          ButtonLong(
            title: tr('continue'),
            function: () async {
              context.read<BattleBloc>().add(AddScore());
              Get.find<UserRepository>().user = Get.find<UserRepository>()
                  .user
                  .copyWith(
                      isBegin: true,
                      mapClassic:
                          Get.find<UserRepository>().user.mapClassic + 1);
              await Get.find<UserRepository>().saveUser();
              await router.pushReplacement('/');
            },
          ),
        SizedBox(
          height: 25.h,
        ),
        ButtonLong(
          title: tr('replay'),
          function: () {
            router.pushReplacement('/battle');
          },
        ),
        if (!context.read<BattleBloc>().state.isWin)
          ButtonLong(
            title: tr('exit_menu'),
            function: () {
              router.pushReplacement('/');
            },
          ),
      ],
    );
  }
}

class YesNoModal extends StatelessWidget {
  final BuildContext context;
  final String title;
  const YesNoModal(this.context, this.title, {super.key});

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext context2) {
    return Column(
      children: [
        Text(
          title,
          style: AppText.baseTitle18,
        ),
        SizedBox(
          height: 25.h,
        ),
        ButtonLong(
          title: tr('yes'),
          function: () {
            Navigator.pop(context, true);
          },
        ),
        SizedBox(
          height: 25.h,
        ),
        ButtonLong(
          title: tr('no'),
          function: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}

class TextFieldModel extends StatelessWidget {
  final BuildContext context;
  final String title;
  final TextEditingController nameController = TextEditingController();
  TextFieldModel(this.context, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppText.baseTitle18,
        ),
        SizedBox(height: 25.h),
        TextField(
          controller:
              nameController, // Подключаем TextEditingController к TextField
          style: const TextStyle(fontSize: 22, color: Colors.white),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Введите логин',
            fillColor: Color.fromARGB(26, 255, 255, 255),
            filled: true,
          ),
        ),
        SizedBox(height: 25.h),
        ButtonLong(
          title: tr('done'),
          function: () {
            Navigator.pop(context, nameController.text);
          },
        ),
      ],
    );
  }
}
