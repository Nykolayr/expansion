import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/value.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  userRepository = await UserRepository.create();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ru', 'RU'), Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: Locale(
          Platform.localeName.split('_')[0], Platform.localeName.split('_')[1]),
      child: const MyApp(),
    ),
  );
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
    );
  }
}
