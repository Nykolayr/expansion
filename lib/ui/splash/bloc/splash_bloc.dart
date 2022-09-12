import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  static const int _count = 98;

  SplashBloc() : super(const SplashInitial()) {
    on<LoadBegin>(_onStarted);
  }

  void _onStarted(LoadBegin event, Emitter<SplashState> emit) async {
    for (int k = _count; k > 0; k--) {
      // emit(SplashIsLoad(k));
      emit(SplashIsLoad.copyWith(k));
      await Future.delayed(const Duration(
        milliseconds: 250,
      ));
    }
    emit(const SplashLoadSucsess());
  }
}
