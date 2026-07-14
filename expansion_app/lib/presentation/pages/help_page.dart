import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/help/help_catalog.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/battle/battle_entity_sprite.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';

/// Справка: «Основное» (бой, карта…) и «Объекты» (базы / космос).
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const GameMenuBackdrop(),
            GameMenuTheme(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GameScreenBackBar(title: loc.helpTitle),
                Material(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: TabBar(
                    indicatorColor: ExpansionColors.accent,
                    labelColor: ExpansionColors.accent,
                    unselectedLabelColor: Colors.white70,
                    tabs: [
                      Tab(text: loc.helpTabGame),
                      Tab(text: loc.helpTabObjects),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _HelpArticleList(
                        articles: HelpCatalog.gameArticles(loc),
                      ),
                      _HelpArticleList(
                        sections: [
                          _HelpSectionGroup(
                            title: loc.helpSubsectionBases,
                            articles: HelpCatalog.baseArticles(loc),
                          ),
                          _HelpSectionGroup(
                            title: loc.helpSubsectionSpaceObjects,
                            articles: HelpCatalog.spaceObjectArticles(loc),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpSectionGroup {
  const _HelpSectionGroup({required this.title, required this.articles});

  final String title;
  final List<HelpArticle> articles;
}

class _HelpArticleList extends StatelessWidget {
  const _HelpArticleList({
    this.articles = const [],
    this.sections = const [],
  });

  final List<HelpArticle> articles;
  final List<_HelpSectionGroup> sections;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (articles.isNotEmpty)
          ...articles.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _HelpSection(article: a),
            ),
          ),
        for (final section in sections) ...[
          _HelpSubsectionHeader(title: section.title),
          const Gap(8),
          ...section.articles.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _HelpSection(article: a),
            ),
          ),
          const Gap(8),
        ],
      ],
    );
  }
}

class _HelpSubsectionHeader extends StatelessWidget {
  const _HelpSubsectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: ExpansionColors.accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection({required this.article});

  final HelpArticle article;

  static const double _imageBaseSize = 72;

  @override
  Widget build(BuildContext context) {
    final hasImage = article.imageAsset != null;

    return Card(
      color: Colors.black.withValues(alpha: 0.55),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Gap(8),
                  Text(
                    article.body,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (hasImage) ...[
              const Gap(12),
              BattleEntitySprite(
                assetPath: article.imageAsset!,
                size: _imageBaseSize * article.imageScale,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
