import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expansion/l10n/app_localizations.dart';

void main() {
  testWidgets('Splash показывает заголовок ЭКСПАНСИЯ', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        home: Builder(
          builder: (context) {
            final loc = AppLocalizations.of(context)!;
            return Center(child: Text(loc.splashTitleExpansion));
          },
        ),
      ),
    );

    expect(find.text('ЭКСПАНСИЯ'), findsOneWidget);
  });
}
