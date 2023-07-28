// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/splash/sub/update/bloc/update_bloc.dart';
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
      body: Stack(
        children: [
          SizedBox(
            height: deviceSize.height.h,
            child: Image.asset(
              'assets/images/fon1.png',
              fit: BoxFit.fill,
            ),
          ),
          appButtonBack(tr("upgrades")),
          BlocConsumer<UpdateBloc, UpdateState>(
              listener: (context, state) async {},
              builder: (context, state) {
                return Container(
                  width: deviceSize.width.w,
                  padding: EdgeInsets.symmetric(
                    vertical: 75.h,
                    horizontal: 45.w,
                  ),
                  child: const Column(
                    children: [],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
