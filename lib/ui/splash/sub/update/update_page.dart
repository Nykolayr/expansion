// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/upgrade.dart';
import 'package:expansion/ui/battle/widgets/modal.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/splash/sub/update/bloc/update_bloc.dart';
import 'package:expansion/ui/splash/sub/update/widgets.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/ui/widgets/messages.dart';
import 'package:expansion/ui/widgets/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<UpdateBloc>();
    return Scaffold(
      bottomNavigationBar: Container(
        color: AppColor.darkBlue,
        height: 80,
        child: ButtonLongSimple(
          title: tr('reset_ugrades'),
          function: () async {
            bool? result = await showModalBottom(
                context, YesNoModal(context, tr('want_ugrades')));
            if (result != null && result) {
              if (context.mounted) {
                context.read<UpdateBloc>().add(ResetScore());
              }
            }
          },
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
          appButtonBack(tr("upgrades")),
          BlocBuilder<UpdateBloc, UpdateState>(builder: (context, state) {
            return Container(
              width: deviceSize.width,
              padding: const EdgeInsets.only(top: 75, right: 20, left: 20),
              child: Column(
                children: [
                  titleWithSvg(tr("score",
                      args: [userRepository.upOur.score.toString()])),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (Upgrade item in state.upgrade.list)
                            upgradeAdding(item, context)
                        ],
                      ),
                    ),
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
