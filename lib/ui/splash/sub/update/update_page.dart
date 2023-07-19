// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/ui/splash/sub/update/bloc/update_bloc.dart';
import 'package:expansion/utils/text.dart';
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
            height: deviceSize.height,
            child: Image.asset(
              'assets/images/fon1.png',
              fit: BoxFit.fill,
            ),
          ),
          BlocConsumer<UpdateBloc, UpdateState>(
              listener: (context, state) async {},
              builder: (context, state) {
                return Container(
                  width: deviceSize.width,
                  padding: EdgeInsets.symmetric(
                    vertical: 75.h,
                    horizontal: 45.w,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          tr("upgrades"),
                          style: AppText.baseText.copyWith(
                            fontSize: 30.sp,
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
