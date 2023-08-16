// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:get/get.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  static const int _count = 98;

  SplashBloc()
      : super(SplashState(
            count: 100,
            isCheck: Get.find<UserRepository>().game.isSplash,
            isSuccess: false)) {
    on<LoadBegin>(_onStarted);
    on<SplashEnd>(onEndSplash);
  }

  _onStarted(LoadBegin event, Emitter<SplashState> emit) async {
    for (int k = _count; k > 0; k--) {
      emit(state.copyWith(count: k));
      await Future.delayed(Duration(
        milliseconds: Get.find<UserRepository>().game.isSplash ? 240 : 0,
      ));
    }
    emit(state.copyWith(isSuccess: true));
  }

  void onEndSplash(SplashEnd event, Emitter<SplashState> emit) async {}
}
