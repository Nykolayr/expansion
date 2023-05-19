import 'package:computer/computer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/repository/user_repository.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;

import 'utils/value.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .whenComplete(() async {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    userRepository = await UserRepository.create();
    // Добавляем два isolate
    computer = Computer.create();
    await computer.turnOn();
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('ru', 'RU'), Locale('en', 'US')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        startLocale: userRepository.settings.lang.locale,
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Space expansion',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData(
        canvasColor: AppColor.darkBlue,
        textTheme: GoogleFonts.kellySlabTextTheme(),
      ),
      builder: (context, child) {
        deviceSize = Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height);
        ratioXY = Size(standardDeviceSize.width / deviceSize.width,
            standardDeviceSize.height / deviceSize.height);
        final mq = MediaQuery.of(context);
        double fontScale = mq.textScaleFactor.clamp(0.9, 1.1);
        return Directionality(
          textDirection: ui.TextDirection.ltr,
          child: MediaQuery(
            data: mq.copyWith(textScaleFactor: fontScale),
            child: Scaffold(
              body: child!,
            ),
          ),
        );
      },
    );
  }
}
