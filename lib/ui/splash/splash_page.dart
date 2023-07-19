// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/ui/widgets/line_buttons.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../utils/text.dart';
import 'bloc/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) async {
        if (state is SplashLoadSucsess) {
          // context.read<SplashBloc>().add(const SplashEnd());
        }
      }, builder: (context, state) {
        double widht = deviceSize.width / 3 - 6;
        double height = widht / 3 + 10;
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                height: deviceSize.height,
                child: Image.asset(
                  'assets/splash.png',
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      height: (state is SplashLoadSucsess) ? height + 40.h : 0,
                      duration: const Duration(seconds: 2),
                      child: const LineButtons(),
                    ),
                    AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      height: (state is SplashLoadSucsess) ? 0 : height + 40.h,
                      duration: const Duration(seconds: 2),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      tr("space"),
                      style: AppText.baseTextShadow.copyWith(fontSize: 42.sp),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      tr("EXPANSION"),
                      style: AppText.baseTextShadow.copyWith(fontSize: 52.sp),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: (state is SplashLoadSucsess)
                    ? const SizedBox.shrink()
                    : Loader(state),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  height: (state is SplashLoadSucsess) ? height + 40.h : 0,
                  width: deviceSize.width,
                  duration: const Duration(seconds: 2),
                  child: userRepository.user.isBegin
                      ? ButtonLong(
                          title: tr('begin_game'),
                          function: () => context.go('/new_game'),
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
  const Loader(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1000,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          userRepository.user.isBegin
              ? AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  width: (state.count > 96.w || state is SplashLoadSucsess)
                      ? 0
                      : deviceSize.width - 20,
                  duration: const Duration(seconds: 2),
                  child: Card(
                    elevation: 10,
                    color: AppColor.darkBlue,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: AppColor.darkYeloow, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin:
                        EdgeInsets.symmetric(vertical: 25.h, horizontal: 10.w),
                    child: Container(
                        height: (state.count > 83)
                            ? 55.h
                            : (state is SplashLoadSucsess)
                                ? deviceSize.height / 2
                                : null,
                        padding: const EdgeInsets.all(15),
                        child:
                            (state.count > 83 || (state is SplashLoadSucsess))
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
                )
              : const SizedBox.shrink(),
          Text(
            tr('load'),
            style: AppText.baseText.copyWith(color: AppColor.white),
          ),
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
                    width: 2,
                    color: AppColor.darkYeloow,
                  ),
                ),
              ),
              Container(
                width: 220 - 220 * (state.count) / 100,
                height: 18,
                color: AppColor.darkYeloow,
              ),
            ],
          ),
          const SizedBox(
            height: 35,
          ),
        ],
      ),
    );
  }
}
