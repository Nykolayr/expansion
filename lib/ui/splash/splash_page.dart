// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/text.dart';
import 'bloc/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) async {
        if (state is SplashLoadSucsess) {}
        if (state is SplashInitial) {
          context.read<SplashBloc>().add(const LoadBegin());
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/splash.png',
                fit: BoxFit
                    .fill, // I thought this would fill up my Container but it doesn't
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    tr("space"),
                    style: AppText.baseText.copyWith(fontSize: 42),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    tr("EXPANSION"),
                    style: AppText.baseText.copyWith(fontSize: 52),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Loader(state),
            ),
          ],
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
          AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            width:
                (state.count > 96) ? 0 : MediaQuery.of(context).size.width - 20,
            duration: const Duration(seconds: 2),
            child: Card(
              elevation: 10,
              color: AppColor.darkBlue,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColor.darkYeloow, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Container(
                  height: (state.count > 83) ? 55 : null,
                  padding: const EdgeInsets.all(15),
                  child: (state.count > 83)
                      ? const SizedBox.shrink()
                      : AnimatedTextKit(
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TyperAnimatedText(tr('pretext'),
                                textStyle: AppText.baseText.copyWith(
                                    fontSize: 20, color: AppColor.white)),
                          ],
                        )),
            ),
          ),
          Text(
            tr('load'),
            style: AppText.baseText.copyWith(color: AppColor.white),
          ),
          const SizedBox(
            height: 25,
          ),
          Stack(
            children: [
              Container(
                width: 220,
                height: 18,
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
