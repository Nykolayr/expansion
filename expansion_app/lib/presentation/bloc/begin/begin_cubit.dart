import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/domain/entities/guest_profile.dart';
import 'package:expansion/domain/entities/player_meta_progress.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/enums/univer_kind.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/begin/begin_state.dart';

class BeginCubit extends Cubit<BeginState> {
  BeginCubit(this._guest) : super(const BeginState());

  final GuestProfileRepository _guest;

  Future<void> load() async {
    final guest = await _guest.load();
    emit(
      state.copyWith(
        difficulty: guest.difficulty,
        univerKind: guest.univerKind,
      ),
    );
  }

  void selectDifficulty(GameDifficulty difficulty) {
    emit(state.copyWith(difficulty: difficulty));
  }

  void selectUniver(UniverKind kind) {
    if (!kind.isPlayable) return;
    emit(state.copyWith(univerKind: kind));
  }

  /// Новая кампания: сброс прогресса classic, миссия 1.
  Future<void> startNewCampaign() async {
    emit(state.copyWith(isSaving: true));
    AppLog.trace('begin new campaign diff=${state.difficulty}', tag: 'Begin');

    await _guest.save(
      GuestProfile(
        mapClassic: 1,
        scoreClassic: 0,
        difficulty: state.difficulty,
        univerKind: state.univerKind,
        firstBattleCompleted: false,
        meta: PlayerMetaProgress.fresh(),
      ),
    );

    emit(state.copyWith(isSaving: false));
  }
}
