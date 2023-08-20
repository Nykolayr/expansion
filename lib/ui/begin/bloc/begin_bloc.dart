import 'package:equatable/equatable.dart';
import 'package:expansion/domain/models/game/game.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part 'begin_event.dart';
part 'begin_state.dart';

class BeginBloc extends Bloc<BeginEvent, BeginState> {
  BeginBloc() : super(BeginInitial()) {
    on<ChangeLevel>(_onLevel);
    on<ChangeUniver>(_onUniver);
    on<ChangeHint>(_onHint);
  }
  _onLevel(ChangeLevel event, Emitter<BeginState> emit) async {
    Get.find<UserRepository>().game =
        Get.find<UserRepository>().game.copyWith(level: event.level);
    setChange(emit);
  }

  _onUniver(ChangeUniver event, Emitter<BeginState> emit) async {
    Get.find<UserRepository>().game =
        Get.find<UserRepository>().game.copyWith(univer: event.univer);
    setChange(emit);
  }

  _onHint(ChangeHint event, Emitter<BeginState> emit) async {
    setChange(emit);
  }

  setChange(Emitter<BeginState> emit) {
    emit(BeginInitial());
    Get.find<UserRepository>().saveUser();
    emit(BeginChange());
  }
}
