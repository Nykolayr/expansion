import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expansion/utils/value.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<ChangeSound>(_onSound);
  }

  _onSound(ChangeSound event, Emitter<SettingState> emit) async {
    emit(SettingInitial());
    userRepository.saveUser();
    emit(SettingChange());
  }
}
