import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:computer/computer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/domain/repository/maps_repository.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/firebase_options.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surf_logger/surf_logger.dart';
// ignore: non_constant_identifier_names

const isEdit = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .whenComplete(() async {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    // Добавляем два isolate
    final computerTic = Computer.create();
    await computerTic.turnOn();
    Get.put(() => computerTic);
    await Get.putAsync(() async {
      final userRepository = await UserRepository.getInstance();
      return userRepository;
    });
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('ru', 'RU'), Locale('en', 'US')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: standardDeviceSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp.router(
            title: 'Space expansion',
            debugShowCheckedModeBanner: false,
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
              // добавил логирование для отладки
              Logger.addStrategy(DebugLogStrategy());
              final name = Get.find<UserRepository>().user.name;
              if (name == 'guest') {
                Get.find<UserRepository>().user =
                    Get.find<UserRepository>().user.copyWith(name: tr(name));
              }
              deviceSize = Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height);
              Get
                ..putAsync(() async {
                  final gameRepository = GameRepository();
                  await gameRepository.init();
                  return gameRepository;
                })
                ..putAsync(() async {
                  final mapsRepository = MapsRepository();
                  await mapsRepository.init();
                  return mapsRepository;
                });
              final mq = MediaQuery.of(context);
              final fontScale = mq.textScaleFactor.clamp(0.9, 1.1);
              return Directionality(
                textDirection: ui.TextDirection.ltr,
                child: MediaQuery(
                  data: mq.copyWith(textScaleFactor: fontScale),
                  child: Scaffold(
                    body: child,
                  ),
                ),
              );
            },
          );
        });
  }
}
