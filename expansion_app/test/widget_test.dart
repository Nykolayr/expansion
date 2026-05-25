import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/splash/splash_cubit.dart';
import 'package:expansion/presentation/pages/splash_page.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      PrefsKeys.splashShowIntro: false,
    });
    await initDependencies();
  });

  testWidgets('SplashPage показывает заголовок ЭКСПАНСИЯ', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await sl<SplashCubit>().start(introTextLength: 1);
    });

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        home: const SplashPage(),
      ),
    );

    expect(find.text('ЭКСПАНСИЯ'), findsOneWidget);
  });
}
