import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/progress/progress.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/splash/sub/progress/bloc/progress_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
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
      bottomNavigationBar: Container(
        color: AppColor.darkBlue,
        height: 150,
        width: deviceSize.width,
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            Text(
              tr("guestWarning"),
              style: AppText.baseBody,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.h,
            ),
            ButtonLongSimple(
              title: tr('loginAndRegister'),
              function: () {
                router.go('/profile/profile_login');
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
          appButtonBack(tr("progress")),
          BlocBuilder<ProgressBloc, ProgressState>(builder: (context, state) {
            return Container(
              width: deviceSize.width,
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 70.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${tr("Ваши достижения")}:',
                        style: TextStyle(
                          color: AppColor.red,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        userRepository.upOur.allScore.toString(),
                        style: TextStyle(
                          color: AppColor.red,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Divider(
                    height: 2.h,
                    color: AppColor.darkYeloow,
                    thickness: 2,
                    endIndent: 2,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    //This
                    child: SingleChildScrollView(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 25.h,
                          ),
                          Text(
                            tr("Достижения других игроков"),
                            style: AppText.baseBodyBold,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15.h),
                          for (int k = 1; k < yourDataList.length + 1; k++)
                            NameAndScoreWidget(
                              user: yourDataList[k - 1],
                              id: 5,
                              index: k,
                            ),
                          SizedBox(height: 20.h)
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
