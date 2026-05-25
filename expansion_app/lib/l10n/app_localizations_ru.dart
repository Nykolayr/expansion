// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Expansion';

  @override
  String get homeTitle => 'Космическое расширение';

  @override
  String get homeMessage =>
      'Каркас готов: Clean Architecture, BLoC, GetIt, GoRouter.\nДальше — перенос игровых экранов и ассетов.';
}
