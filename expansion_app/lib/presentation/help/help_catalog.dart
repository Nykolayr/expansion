import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/domain/enums/battle_visual_id.dart';
import 'package:expansion/l10n/app_localizations.dart';

/// Одна карточка в справке.
class HelpArticle {
  const HelpArticle({
    required this.title,
    required this.body,
    this.imageAsset,
    this.imageScale = 1.0,
  });

  final String title;
  final String body;
  final String? imageAsset;
  final double imageScale;
}

/// Тексты и спрайты — как в интро перед первым появлением.
abstract final class HelpCatalog {
  static List<HelpArticle> gameArticles(AppLocalizations loc) => [
        HelpArticle(title: loc.helpBattleTitle, body: loc.helpBattleBody),
        HelpArticle(
          title: loc.battleTutorialDragTitle,
          body: loc.battleTutorialDragBody,
        ),
        HelpArticle(
          title: loc.battleTutorialCaptureTitle,
          body: loc.battleTutorialCaptureBody,
        ),
        HelpArticle(
          title: loc.battleTutorialUpgradeTitle,
          body: loc.battleTutorialUpgradeBody,
        ),
        HelpArticle(
          title: loc.battleTutorialGoalTitle,
          body: loc.battleTutorialGoalBody,
        ),
        HelpArticle(title: loc.helpMapTitle, body: loc.helpMapBody),
        HelpArticle(
          title: loc.mapTutorialTitle,
          body: loc.mapTutorialBody,
        ),
        HelpArticle(title: loc.helpUpgradesTitle, body: loc.helpUpgradesBody),
        HelpArticle(
          title: loc.helpDifficultyTitle,
          body: loc.helpDifficultyBody,
        ),
      ];

  static List<HelpArticle> baseArticles(AppLocalizations loc) {
    final paths = BattleAssets.targetAssetPaths;
    return [
      HelpArticle(
        title: loc.battleIntroSmallBaseTitle,
        body: loc.battleIntroSmallBaseBody,
        imageAsset: paths[BattleVisualId.baseSmall],
        imageScale: 0.78,
      ),
      HelpArticle(
        title: loc.battleIntroMediumBaseTitle,
        body: loc.battleIntroMediumBaseBody,
        imageAsset: BattleAssets.neutralMiddle,
      ),
      HelpArticle(
        title: loc.battleIntroLargeBaseTitle,
        body: loc.battleIntroLargeBaseBody,
        imageAsset: BattleAssets.neutralLarge,
      ),
      HelpArticle(
        title: loc.battleIntroRichBaseTitle,
        body: loc.battleIntroRichBaseBody,
        imageAsset: paths[BattleVisualId.baseRich],
        imageScale: 0.85,
      ),
      HelpArticle(
        title: loc.battleIntroShieldedBaseTitle,
        body: loc.battleIntroShieldedBaseBody,
        imageAsset: paths[BattleVisualId.baseShielded],
        imageScale: 0.9,
      ),
      HelpArticle(
        title: loc.battleIntroFactoryBaseTitle,
        body: loc.battleIntroFactoryBaseBody,
        imageAsset: paths[BattleVisualId.baseFactory],
        imageScale: 0.78,
      ),
      HelpArticle(
        title: loc.battleIntroBunkerBaseTitle,
        body: loc.battleIntroBunkerBaseBody,
        imageAsset: paths[BattleVisualId.baseBunker],
      ),
    ];
  }

  static List<HelpArticle> spaceObjectArticles(AppLocalizations loc) {
    final paths = BattleAssets.targetAssetPaths;
    return [
      HelpArticle(
        title: loc.battleMeteoriteTutorialTitle,
        body: loc.battleMeteoriteTutorialBody,
        imageAsset: paths[BattleVisualId.hazardAsteroid],
        imageScale: 0.9,
      ),
      HelpArticle(
        title: loc.battleIntroCometTitle,
        body: loc.battleIntroCometBody,
        imageAsset: paths[BattleVisualId.hazardComet],
        imageScale: 0.9,
      ),
      HelpArticle(
        title: loc.battleDebrisTutorialTitle,
        body: loc.battleDebrisTutorialBody,
        imageAsset: paths[BattleVisualId.hazardDebris],
        imageScale: 0.9,
      ),
      HelpArticle(
        title: loc.battleIntroPulseTitle,
        body: loc.battleIntroPulseBody,
        imageAsset: paths[BattleVisualId.hazardPulse],
        imageScale: 0.9,
      ),
      HelpArticle(
        title: loc.battleIntroDroneTitle,
        body: loc.battleIntroDroneBody,
        imageAsset: paths[BattleVisualId.hazardDrone],
        imageScale: 0.9,
      ),
      HelpArticle(
        title: loc.battleIntroMineTitle,
        body: loc.battleIntroMineBody,
        imageAsset: paths[BattleVisualId.hazardMine],
        imageScale: 0.9,
      ),
      HelpArticle(
        title: loc.battleIntroSolarWindTitle,
        body: loc.battleIntroSolarWindBody,
        imageAsset: paths[BattleVisualId.hazardSolarWind],
        imageScale: 0.9,
      ),
      HelpArticle(
        title: loc.battleIntroWormholeTitle,
        body: loc.battleIntroWormholeBody,
        imageAsset: paths[BattleVisualId.hazardWormhole],
        imageScale: 0.9,
      ),
    ];
  }
}
