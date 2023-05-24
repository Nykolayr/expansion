import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/text.dart';
import 'package:flutter/material.dart';

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
        const SizedBox(
          height: 25,
        ),
        if (isWin)
          ButtonLong(
            title: tr('continue'),
            function: () {
              Navigator.of(context).pop();
            },
          ),
        const SizedBox(
          height: 25,
        ),
        ButtonLong(
          title: tr('replay'),
          function: () {
            Navigator.of(context).pop();
          },
        ),
        if (!isWin)
          ButtonLong(
            title: tr('exit_menu'),
            function: () {
              Navigator.of(context).pop();
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
        const SizedBox(
          height: 25,
        ),
        ButtonLong(
          title: tr('yes'),
          function: () {
            Navigator.pop(context, true);
          },
        ),
        const SizedBox(
          height: 25,
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
