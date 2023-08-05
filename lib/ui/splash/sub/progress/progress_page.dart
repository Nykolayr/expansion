// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/progress/progress.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/splash/sub/progress/bloc/progress_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<ProgressBloc>();

    yourDataList.sort((a, b) => b.score.compareTo(a.score));

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
          appButtonBack(tr("progress")),
          BlocConsumer<ProgressBloc, ProgressState>(
              listener: (context, state) async {},
              builder: (context, state) {
                return Container(
                  width: deviceSize.width,
                  padding: const EdgeInsets.symmetric(
                    vertical: 75,
                    horizontal: 20,
                  ),
                  child: Column(children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    NameAndScoreWidget(
                      name: tr("Ваши достижения"),
                      score: userRepository.upOur.allScore,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Divider(
                      height: 2.h,
                      color: const Color.fromARGB(255, 250, 190, 13),
                      thickness: 2,
                      endIndent: 2, // Отступ справа от черты
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      tr("Достижения других игроков"),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 181),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: yourDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = yourDataList[index];

                          return Column(
                            children: [
                              NameAndScoreWidget(
                                name: item.name,
                                score: item.score,
                                colortext: Color.fromARGB(255, 250, 190, 13),
                              ),
                              SizedBox(height: 5.h), // Отступ между игроками
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(children: [
                          Text(
                            tr("guestWarning"),
                            style: TextStyle(
                              color: Color.fromARGB(255, 250, 190, 13),
                              fontSize: 16.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.h),
                          ButtonLong(
                            title: tr('loginAndRegister'),
                            function: () => router.go('/profile/profile_login'),
                          )
                        ])
                      ],
                    ),
                  ]),
                );
              }),
        ],
      ),
    );
  }
}
