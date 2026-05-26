import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/data/datasources/local/game_database.dart';
import 'package:expansion/data/seed/campaign_content_seeder.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_state.dart';

/// Подготовка приложения перед меню: prefs уже в [main], здесь — локальная БД.
///
/// Позже: проверка версии контента, синк с API.
class AppBootstrapCubit extends Cubit<AppBootstrapState> {
  AppBootstrapCubit(this._gameDatabase, this._contentSeeder)
      : super(const AppBootstrapState.idle());

  final GameDatabase _gameDatabase;
  final CampaignContentSeeder _contentSeeder;

  Future<void> initialize() async {
    if (state.isReady) {
      AppLog.trace('bootstrap skip (already ready)', tag: 'Bootstrap');
      return;
    }

    emit(state.copyWith(status: AppBootstrapStatus.loading));
    AppLog.trace('bootstrap start', tag: 'Bootstrap');

    try {
      await _gameDatabase.database;
      await _contentSeeder.seedIfNeeded();
      emit(state.copyWith(status: AppBootstrapStatus.ready));
      AppLog.trace('bootstrap ready', tag: 'Bootstrap');
    } catch (e, stackTrace) {
      AppLog.error(
        'bootstrap failed',
        error: e,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          status: AppBootstrapStatus.failed,
          errorMessage: e.toString(),
        ),
      );
      rethrow;
    }
  }
}
