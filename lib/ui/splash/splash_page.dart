import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/splash/bloc/splash_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/ui/widgets/line_buttons.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SplashBloc, SplashState>(builder: (context, state) {
        final widht = deviceSize.width / 3;
        final height = widht / 3 + 10;
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Image.asset(
                  'assets/splash.png',
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      height: state.isSuccess ? height.h + 40 : 0,
                      duration: const Duration(seconds: 2),
                      child: const LineButtons(),
                    ),
                    AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      height: state.isSuccess ? 0 : height.h + 40,
                      duration: const Duration(seconds: 2),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      tr('space'),
                      style: AppText.baseTextShadow.copyWith(fontSize: 42.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      tr('EXPANSION'),
                      style: AppText.baseTextShadow.copyWith(fontSize: 52.sp),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child:
                    state.isSuccess ? const SizedBox.shrink() : Loader(state),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  height: (state.isSuccess) ? height.h + 40 : 0,
                  width: deviceSize.width,
                  duration: const Duration(seconds: 2),
                  child: Get.find<UserRepository>().game.isSplash
                      ? ButtonLong(
                          title: tr('begin_game'),
                          function: () async {
                            Get.find<UserRepository>().game =
                                Get.find<UserRepository>()
                                    .game
                                    .copyWith(isSplash: false);
                            await Get.find<UserRepository>().saveUser();
                            router.go('/new_game');
                          },
                          isWidth: true,
                        )
                      : const LineButtons(
                          isTop: false,
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class Loader extends StatelessWidget {
  final SplashState state;
  const Loader(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (Get.find<UserRepository>().game.isSplash)
            Column(
              children: [
                AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  width: (state.count > 96 || state.isSuccess)
                      ? 0
                      : deviceSize.width - 20,
                  duration: const Duration(seconds: 2),
                  child: Card(
                    elevation: 10,
                    color: AppColor.darkBlue,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColor.darkYeloow, width: 2.w),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 10),
                    child: Container(
                        height: (state.count > 83)
                            ? 55.h
                            : state.isSuccess
                                ? deviceSize.height / 2
                                : null,
                        padding: const EdgeInsets.all(15),
                        child: (state.count > 83 || state.isSuccess)
                            ? const SizedBox.shrink()
                            : AnimatedTextKit(
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TyperAnimatedText(tr('pretext'),
                                      textStyle: AppText.baseText.copyWith(
                                          fontSize: 20.sp,
                                          color: AppColor.white)),
                                ],
                              )),
                  ),
                ),
                Text(
                  tr('load'),
                  style: AppText.baseText.copyWith(color: AppColor.white),
                ),
              ],
            )
          else
            const SizedBox.shrink(),
          SizedBox(
            height: 25.h,
          ),
          Stack(
            children: [
              Container(
                width: 220.w,
                height: 18.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.w,
                    color: AppColor.darkYeloow,
                  ),
                ),
              ),
              Container(
                width: 220.w - 220 * (state.count) / 100,
                height: 18.h,
                color: AppColor.darkYeloow,
              ),
            ],
          ),
          SizedBox(
            height: 35.h,
          ),
        ],
      ),
    );
  }
}
