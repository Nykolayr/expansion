import 'package:equatable/equatable.dart';
import 'package:expansion/domain/models/upgrade.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
part 'update_event.dart';
part 'update_state.dart';

UserRepository userRepository = Get.find<UserRepository>();

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateBloc() : super(UpdateState.initial()) {
    on<ChangeUdrade>(_onChangeUdrade);
    on<ResetScore>(_onResetScore);
  }
  _onChangeUdrade(ChangeUdrade event, Emitter<UpdateState> emit) async {
    userRepository.upOur.toUpgrade(event.type);
    userRepository.saveUser();
    emit(state.copyWith(upgrade: userRepository.upOur));
  }

  _onResetScore(ResetScore event, Emitter<UpdateState> emit) async {
    int score = userRepository.upOur.allScore;
    userRepository.upOur = AllUpgrade.initialOur();
    userRepository.upOur.score = score;
    userRepository.upOur.allScore = score;
    userRepository.saveUser();
    emit(state.copyWith(upgrade: userRepository.upOur));
  }
}
