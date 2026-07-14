import 'package:expansion/data/models/player_meta_progress_codec.dart';
import 'package:expansion/domain/entities/guest_profile.dart';
import 'package:expansion/domain/entities/player_meta_progress.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/enums/univer_kind.dart';

/// JSON профиля с сервера (`GET/PUT /profile`).
abstract final class GuestProfileJsonCodec {
  static GuestProfile fromApi(Map<String, dynamic> json) {
    final metaRaw = json['meta'];
    final meta = metaRaw is Map<String, dynamic>
        ? PlayerMetaProgressCodec.fromMap(metaRaw)
        : PlayerMetaProgress.fresh();

    final seenRaw = json['seenFeatureIntros'];
    final seen = seenRaw is List
        ? seenRaw.map((e) => e.toString()).toSet()
        : <String>{};

    final displayName = (json['realName'] as String?)?.trim().isNotEmpty == true
        ? json['realName'] as String
        : (json['displayName'] as String? ?? '');

    return GuestProfile(
      mapClassic: json['mapClassic'] as int? ?? 1,
      scoreClassic: json['scoreClassic'] as int? ?? 0,
      difficulty: GameDifficulty.fromStorage(json['difficulty'] as String?),
      univerKind: UniverKind.fromStorage(json['univerKind'] as String?),
      firstBattleCompleted: json['firstBattleCompleted'] as bool? ?? false,
      displayName: displayName.trim(),
      defeatStreakSceneId: json['defeatStreakSceneId'] as int? ?? 0,
      defeatStreakCount: json['defeatStreakCount'] as int? ?? 0,
      asteroidTutorialSeen: json['asteroidTutorialSeen'] as bool? ?? false,
      debrisTutorialSeen: json['debrisTutorialSeen'] as bool? ?? false,
      mission1TutorialCompleted:
          json['mission1TutorialCompleted'] as bool? ?? false,
      mapTutorialSeen: json['mapTutorialSeen'] as bool? ?? false,
      seenFeatureIntros: seen,
      campaignStartedAtMillis:
          json['campaignStartedAtMillis'] as int? ?? 0,
      campaignEpilogueSeenForCount:
          json['campaignEpilogueSeenForCount'] as int? ?? 0,
      adsRemoved: json['adsRemoved'] as bool? ?? false,
      supporterTier: json['supporterTier'] as int? ?? 0,
      meta: meta,
    );
  }

  static Map<String, dynamic> toApi(
    GuestProfile profile, {
    String? realName,
  }) {
    return {
      'mapClassic': profile.mapClassic,
      'scoreClassic': profile.scoreClassic,
      'difficulty': profile.difficulty.name,
      'univerKind': profile.univerKind.name,
      'firstBattleCompleted': profile.firstBattleCompleted,
      'displayName': profile.displayName,
      ...? (realName != null ? {'realName': realName} : null),
      'defeatStreakSceneId': profile.defeatStreakSceneId,
      'defeatStreakCount': profile.defeatStreakCount,
      'asteroidTutorialSeen': profile.asteroidTutorialSeen,
      'debrisTutorialSeen': profile.debrisTutorialSeen,
      'mission1TutorialCompleted': profile.mission1TutorialCompleted,
      'mapTutorialSeen': profile.mapTutorialSeen,
      'seenFeatureIntros': profile.seenFeatureIntros.toList(),
      'campaignStartedAtMillis': profile.campaignStartedAtMillis,
      'campaignEpilogueSeenForCount': profile.campaignEpilogueSeenForCount,
      'adsRemoved': profile.adsRemoved,
      'supporterTier': profile.supporterTier,
      'meta': PlayerMetaProgressCodec.toMap(profile.meta),
    };
  }
}
