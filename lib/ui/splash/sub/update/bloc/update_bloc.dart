import 'package:equatable/equatable.dart';
import 'package:expansion/domain/models/upgrade.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
part 'update_event.dart';
part 'update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateBloc() : super(UpdateState.initial()) {
    on<ChangeUdrade>(_onChangeUdrade);
    on<ResetScore>(_onResetScore);
  }
  _onChangeUdrade(ChangeUdrade event, Emitter<UpdateState> emit) async {
    Get.find<UserRepository>().upOur.toUpgrade(event.type);
    Get.find<UserRepository>().saveUser();
    emit(state.copyWith(upgrade: Get.find<UserRepository>().upOur));
  }

  _onResetScore(ResetScore event, Emitter<UpdateState> emit) async {
    int score = Get.find<UserRepository>().upOur.allScore;
    Get.find<UserRepository>().upOur = AllUpgrade.initialOur();
    Get.find<UserRepository>().upOur.score = score;
    Get.find<UserRepository>().upOur.allScore = score;
    Get.find<UserRepository>().saveUser();
    emit(state.copyWith(upgrade: Get.find<UserRepository>().upOur));
  }
}
