import 'package:expansion/domain/entities/guest_profile.dart';

/// Прогресс кампании Classic (без привязки к фиксированному числу миссий).
abstract final class CampaignProgress {
  static bool isClassicCampaignComplete(
    GuestProfile guest,
    int missionCount,
  ) =>
      missionCount > 0 && guest.mapClassic > missionCount;

  static bool shouldShowEpilogue(GuestProfile guest, int missionCount) =>
      isClassicCampaignComplete(guest, missionCount) &&
      guest.campaignEpilogueSeenForCount < missionCount;
}
