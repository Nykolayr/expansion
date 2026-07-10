import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/presentation/widgets/battle/battle_victory_fireworks.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

/// Дополнительная кнопка в диалоге исхода боя.
typedef BattleOutcomeExtraAction = ({String label, VoidCallback onTap});

/// Итог боя в стиле игры (карточки + арт; при победе — конфетти).
Future<void> showBattleOutcomeDialog(
  BuildContext context, {
  required bool won,
  required String title,
  required String body,
  required String continueLabel,
  required VoidCallback onContinue,
  String? secondaryLabel,
  VoidCallback? onSecondary,
  List<BattleOutcomeExtraAction> extraActions = const [],
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    builder: (ctx) => _BattleOutcomeDialog(
      won: won,
      title: title,
      body: body,
      continueLabel: continueLabel,
      onContinue: onContinue,
      secondaryLabel: secondaryLabel,
      onSecondary: onSecondary,
      extraActions: extraActions,
    ),
  );
}

class _BattleOutcomeDialog extends StatefulWidget {
  const _BattleOutcomeDialog({
    required this.won,
    required this.title,
    required this.body,
    required this.continueLabel,
    required this.onContinue,
    this.secondaryLabel,
    this.onSecondary,
    this.extraActions = const [],
  });

  final bool won;
  final String title;
  final String body;
  final String continueLabel;
  final VoidCallback onContinue;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final List<BattleOutcomeExtraAction> extraActions;

  @override
  State<_BattleOutcomeDialog> createState() => _BattleOutcomeDialogState();
}

class _BattleOutcomeDialogState extends State<_BattleOutcomeDialog> {
  ConfettiController? _confetti;

  @override
  void initState() {
    super.initState();
    if (widget.won) {
      _confetti = ConfettiController(duration: const Duration(seconds: 4))
        ..play();
    }
  }

  @override
  void dispose() {
    _confetti?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          if (_confetti != null)
            Positioned.fill(
              child: BattleVictoryFireworks(controller: _confetti!),
            ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _GameMessageCard(
                  width: width - 44,
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: ExpansionTextStyles.bodyAccent(context, 22),
                  ),
                ),
                const Gap(16),
                Container(
                  width: width - 60,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: ExpansionColors.accent, width: 2),
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(
                        widget.won
                            ? BattleAssets.battleWinArt
                            : BattleAssets.battleDefeatArt,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(16),
                _GameMessageCard(
                  width: width - 44,
                  child: Text(
                    widget.body,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ExpansionColors.white,
                        ),
                  ),
                ),
                const Gap(20),
                if (widget.secondaryLabel != null && widget.onSecondary != null) ...[
                  GameLongButton(
                    label: widget.secondaryLabel!,
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onSecondary!();
                    },
                  ),
                  const Gap(12),
                ],
                for (final action in widget.extraActions) ...[
                  GameLongButton(
                    label: action.label,
                    onPressed: () {
                      Navigator.of(context).pop();
                      action.onTap();
                    },
                  ),
                  const Gap(12),
                ],
                GameLongButton(
                  label: widget.continueLabel,
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onContinue();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameMessageCard extends StatelessWidget {
  const _GameMessageCard({
    required this.width,
    required this.child,
  });

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: ExpansionColors.background.withValues(alpha: 0.96),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: ExpansionColors.accent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(width: width, child: child),
      ),
    );
  }
}
