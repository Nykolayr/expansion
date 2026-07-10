import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/extensions/game_difficulty_l10n.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';

/// Сложность кампании (источник правды — [GuestProfileRepository]).
class GameDifficultyCubit extends Cubit<GameDifficulty> {
  GameDifficultyCubit(this._guest) : super(GameDifficulty.average);

  final GuestProfileRepository _guest;

  Future<void> load() async {
    final guest = await _guest.load();
    emit(guest.difficulty);
  }

  Future<void> setDifficulty(GameDifficulty difficulty) async {
    if (difficulty == state) return;
    AppLog.trace('difficulty set $difficulty', tag: 'Settings');
    await _guest.setDifficulty(difficulty);
    emit(difficulty);
  }

  /// Снижает на один уровень; `false`, если уже easy.
  Future<bool> lowerDifficulty() async {
    final easier = state.easier;
    if (easier == null) return false;
    await setDifficulty(easier);
    return true;
  }
}
