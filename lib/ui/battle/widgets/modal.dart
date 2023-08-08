import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WinLostModal extends StatelessWidget {
  final BuildContext context;
  final bool isWin;
  const WinLostModal(this.context, this.isWin, {Key? key}) : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext context2) {
    return Column(
      children: [
        Text(
          tr('next_step'),
          style: AppText.baseTitle,
        ),
        SizedBox(
          height: 25.h,
        ),
        if (isWin)
          ButtonLong(
            title: tr('continue'),
            function: () {
              context.read<BattleBloc>().add(AddScore());
              router.pushReplacement('/');
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
        if (!isWin)
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
  const YesNoModal(this.context, this.title, {Key? key}) : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext context2) {
    return Column(
      children: [
        Text(
          title,
          style: AppText.baseTitle,
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
  final TextEditingController nameController =
      TextEditingController(); // Добавляем TextEditingController
  TextFieldModel(this.context, this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppText.baseTitle,
        ),
        SizedBox(height: 25.h),
        TextField(
          controller:
              nameController, // Подключаем TextEditingController к TextField
          style: const TextStyle(fontSize: 22, color: Colors.white),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Введите логин",
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
