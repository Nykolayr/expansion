import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/domain/repositories/supporters_repository.dart';
import 'package:expansion/presentation/bloc/supporters/supporters_state.dart';

class SupportersCubit extends Cubit<SupportersState> {
  SupportersCubit(this._supporters) : super(const SupportersState());

  final SupportersRepository _supporters;

  Future<void> load() async {
    emit(state.copyWith(status: SupportersStatus.loading, clearError: true));

    final result = await _supporters.fetchTop();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SupportersStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: SupportersStatus.ready,
          entries: data.entries,
        ),
      ),
    );
  }
}
