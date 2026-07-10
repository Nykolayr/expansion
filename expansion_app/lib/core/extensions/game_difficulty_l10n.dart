import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/l10n/app_localizations.dart';

extension GameDifficultyL10n on GameDifficulty {
  String label(AppLocalizations loc) {
    switch (this) {
      case GameDifficulty.easy:
        return loc.beginDifficultyEasy;
      case GameDifficulty.average:
        return loc.beginDifficultyAverage;
      case GameDifficulty.difficult:
        return loc.beginDifficultyHard;
    }
  }
}

extension GameDifficultySteps on GameDifficulty {
  /// Следующий более лёгкий уровень или `null`, если уже easy.
  GameDifficulty? get easier {
    switch (this) {
      case GameDifficulty.difficult:
        return GameDifficulty.average;
      case GameDifficulty.average:
        return GameDifficulty.easy;
      case GameDifficulty.easy:
        return null;
    }
  }
}
