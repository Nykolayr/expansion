import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/domain/repositories/leaderboard_repository.dart';
import 'package:expansion/presentation/bloc/leaderboard/leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit(this._leaderboard, this._auth) : super(const LeaderboardState());

  final LeaderboardRepository _leaderboard;
  final AuthRepository _auth;

  Future<void> load() async {
    emit(state.copyWith(status: LeaderboardStatus.loading, clearError: true));

    final loggedIn = await _auth.isLoggedIn();
    final result = await _leaderboard.fetchTop();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LeaderboardStatus.failure,
          isLoggedIn: loggedIn,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: LeaderboardStatus.ready,
          entries: data.entries,
          isLoggedIn: loggedIn,
        ),
      ),
    );
  }
}
