import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expansion/domain/models/user/setting/settings.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/cupertino.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<ChangeSound>(_onSound);
    on<ChangeLang>(_onLang);
  }

  _onSound(ChangeSound event, Emitter<SettingState> emit) async {
    emit(SettingInitial());
    userRepository.saveUser();
    emit(SettingChange());
  }

  _onLang(ChangeLang event, Emitter<SettingState> emit) async {
    emit(SettingInitial());
    userRepository.setLang(event.lang);
    emit(SettingChange());
  }
}
