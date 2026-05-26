import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _map = 1;
  int _score = 0;
  int _completed = 0;
  int _enemyPower = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final guest = await sl<GuestProfileRepository>().load();
    if (!mounted) return;
    setState(() {
      _map = guest.mapClassic;
      _score = guest.scoreClassic;
      _completed = (guest.mapClassic - 1).clamp(0, 40);
      _enemyPower = guest.meta.enemyPowerLevel;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.splashBackground, fit: BoxFit.cover),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameScreenBackBar(title: loc.progressTitle),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          _StatCard(
                            title: loc.progressCurrentMission,
                            value: '$_map / 40',
                          ),
                          const Gap(12),
                          _StatCard(
                            title: loc.progressCompleted,
                            value: '$_completed',
                          ),
                          const Gap(12),
                          _StatCard(
                            title: loc.progressScore,
                            value: '$_score',
                          ),
                          const Gap(12),
                          _StatCard(
                            title: loc.progressEnemyPower,
                            value: '$_enemyPower',
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ExpansionColors.background.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: ExpansionColors.accent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: ExpansionColors.accent,
              ),
        ),
      ),
    );
  }
}
