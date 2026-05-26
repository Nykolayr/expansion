import 'package:expansion/domain/enums/meta_upgrade_type.dart';
import 'package:expansion/l10n/app_localizations.dart';

extension MetaUpgradeTypeL10n on MetaUpgradeType {
  String label(AppLocalizations loc) {
    switch (this) {
      case MetaUpgradeType.shipSpeed:
        return loc.metaUpgradeShipSpeed;
      case MetaUpgradeType.shipDurability:
        return loc.metaUpgradeShipDurability;
      case MetaUpgradeType.shipBuildSpeed:
        return loc.metaUpgradeShipBuildSpeed;
      case MetaUpgradeType.resourceIncomeSpeed:
        return loc.metaUpgradeResourceIncome;
      case MetaUpgradeType.shieldDurability:
        return loc.metaUpgradeShield;
      case MetaUpgradeType.beginShips:
        return loc.metaUpgradeBeginShips;
    }
  }
}
