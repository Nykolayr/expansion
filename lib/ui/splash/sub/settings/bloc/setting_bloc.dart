import 'package:equatable/equatable.dart';
import 'package:expansion/domain/models/setting/settings.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<ChangeSound>(_onSound);
    on<ChangeLang>(_onLang);
  }

  Future<void> _onSound(ChangeSound event, Emitter<SettingState> emit) async {
    emit(SettingInitial());
    await Get.find<UserRepository>().saveUser();
    emit(SettingChange());
  }

  Future<void> _onLang(ChangeLang event, Emitter<SettingState> emit) async {
    emit(SettingInitial());
    Get.find<UserRepository>().setLang(event.lang);
    emit(SettingChange());
  }
}
