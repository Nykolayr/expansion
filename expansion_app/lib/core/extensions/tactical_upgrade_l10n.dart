import 'package:expansion/domain/enums/tactical_upgrade_type.dart';
import 'package:expansion/l10n/app_localizations.dart';

extension TacticalUpgradeL10n on TacticalUpgradeType {
  String label(AppLocalizations loc) {
    switch (this) {
      case TacticalUpgradeType.shield:
        return loc.tacticalUpgradeShield;
      case TacticalUpgradeType.buildSpeed:
        return loc.tacticalUpgradeBuild;
      case TacticalUpgradeType.maxShips:
        return loc.tacticalUpgradeMaxShips;
    }
  }
}
