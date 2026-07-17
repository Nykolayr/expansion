import 'package:expansion/domain/entities/campaign_scene.dart';

/// Именованные туманности Classic (по 30 миссий, плитка 5×6).///
/// После 10-й туманности — fallback [virgo] и общий cap темпа AI.
enum CampaignNebulaId {
  orion,
  andromeda,
  horsehead,
  crab,
  eagle,
  lagoon,
  veil,
  carina,
  tarantula,
  virgo,
}

/// Правила нарезки карты кампании и ступеньки темпа AI по туманности.
abstract final class CampaignSectors {
  static const int missionsPerSector = 30;
  static const int columns = 5;
  static const int rowsPerSector = 6;

  /// `enemyTurnDivider = min(cap, 1 + nebulaIndex * step)`.
  static const double enemyTurnDividerStep = 0.15;
  static const double enemyTurnDividerCap = 2.5;

  static int nebulaIndexForMission(int missionId) {
    if (missionId < 1) return 0;
    return (missionId - 1) ~/ missionsPerSector;
  }

  static CampaignNebulaId nebulaIdForIndex(int nebulaIndex) {
    final ids = CampaignNebulaId.values;
    if (nebulaIndex <= 0) return ids.first;
    if (nebulaIndex >= ids.length) return ids.last;
    return ids[nebulaIndex];
  }

  static CampaignNebulaId nebulaIdForMission(int missionId) =>
      nebulaIdForIndex(nebulaIndexForMission(missionId));

  /// Сколько туманностей нужно, чтобы покрыть [missionCount] сцен (неполные — ок).
  static int nebulaCount(int missionCount) {
    if (missionCount <= 0) return 0;
    return (missionCount + missionsPerSector - 1) ~/ missionsPerSector;
  }

  /// Inclusive start, exclusive end of absolute mission ids for [nebulaIndex].
  static (int startId, int endIdExclusive) missionRange(int nebulaIndex) {
    final start = nebulaIndex * missionsPerSector + 1;
    return (start, start + missionsPerSector);
  }

  static double enemyTurnDividerForMission(int missionId) {
    final index = nebulaIndexForMission(missionId);
    final raw = 1.0 + index * enemyTurnDividerStep;
    return raw.clamp(1.0, enemyTurnDividerCap);
  }

  static List<CampaignScene> scenesInNebula(
    List<CampaignScene> all,
    int nebulaIndex,
  ) {
    final (start, end) = missionRange(nebulaIndex);
    final list = all.where((s) => s.id >= start && s.id < end).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    return list;
  }

  static int initialNebulaPage(int currentMissionId, int missionCount) {
    final count = nebulaCount(missionCount);
    if (count <= 0) return 0;
    return nebulaIndexForMission(currentMissionId).clamp(0, count - 1);
  }
}
