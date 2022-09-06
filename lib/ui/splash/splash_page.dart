// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/text.dart';
import 'bloc/splash_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const PreferredSize(
      //   preferredSize: Size.fromHeight(60.0),
      //   child: AppBarWithIcon(),
      // ),
      body: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) async {
        // if (state is SuccessHome) {
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (BuildContext context) => BlocProvider(
        //             create: (_) => ProjectBloc(),
        //             child: const ProjectPage(),
        //           )));
        // }
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

class Loader extends StatefulWidget {
  final SplashState state;
  const Loader(this.state, {super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Container(height: 30, width: 120, color: Colors.yellow);
  }
}
