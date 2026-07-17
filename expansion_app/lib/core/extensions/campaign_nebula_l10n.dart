import 'package:expansion/domain/campaign/campaign_sectors.dart';
import 'package:expansion/l10n/app_localizations.dart';

extension CampaignNebulaIdL10n on CampaignNebulaId {
  String label(AppLocalizations loc) => switch (this) {
        CampaignNebulaId.orion => loc.mapsNebulaOrion,
        CampaignNebulaId.andromeda => loc.mapsNebulaAndromeda,
        CampaignNebulaId.horsehead => loc.mapsNebulaHorsehead,
        CampaignNebulaId.crab => loc.mapsNebulaCrab,
        CampaignNebulaId.eagle => loc.mapsNebulaEagle,
        CampaignNebulaId.lagoon => loc.mapsNebulaLagoon,
        CampaignNebulaId.veil => loc.mapsNebulaVeil,
        CampaignNebulaId.carina => loc.mapsNebulaCarina,
        CampaignNebulaId.tarantula => loc.mapsNebulaTarantula,
        CampaignNebulaId.virgo => loc.mapsNebulaVirgo,
      };
}
