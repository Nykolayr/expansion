import 'package:expansion/domain/enums/univer_kind.dart';
import 'package:expansion/l10n/app_localizations.dart';

extension UniverKindL10n on UniverKind {
  String label(AppLocalizations loc) {
    switch (this) {
      case UniverKind.classic:
        return loc.beginUniverClassic;
      case UniverKind.generated:
        return loc.beginUniverGenerated;
      case UniverKind.strategic:
        return loc.beginUniverStrategic;
    }
  }

  String hint(AppLocalizations loc) {
    switch (this) {
      case UniverKind.classic:
        return loc.beginUniverClassicHint;
      case UniverKind.generated:
        return loc.beginUniverComingSoon;
      case UniverKind.strategic:
        return loc.beginUniverComingSoon;
    }
  }
}
