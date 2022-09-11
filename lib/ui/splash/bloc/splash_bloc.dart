import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  static const int _count = 100;

  SplashBloc() : super(const SplashInitial()) {
    on<LoadBegin>(_onStarted);
  }

  void _onStarted(LoadBegin event, Emitter<SplashState> emit) async {
    for (int k = _count; k > 0; k -= 2) {
      emit(SplashIsLoad(k));
      await Future.delayed(const Duration(
        milliseconds: 100,
      ));
      emit(SplashIsLoad2(k));
    }
    emit(const SplashLoadSucsess());
  }
}
