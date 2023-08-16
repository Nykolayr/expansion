import 'package:equatable/equatable.dart';
import 'package:expansion/data/base_data.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part 'profile_event.dart';
part 'profile_state.dart';

UserRepository userRepository = Get.find<UserRepository>();

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<ChangeUser>(_onChangeUser);
    on<ChangeName>(_onChangeName);
    on<SignOut>(_onSignOut);
  }
  _onSignOut(SignOut event, Emitter<ProfileState> emit) async {
    userRepository.initUser();
    emit(state.copyWith(user: userRepository.user));
  }

  _onChangeUser(ChangeUser event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    Map<String, dynamic> data = await BaseData().loadJson(id: event.uid);
    userRepository = UserRepository.fromJson(data);
    await userRepository.saveUser();
    emit(state.copyWith(user: userRepository.user, isLoading: false));
  }

  _onChangeName(ChangeName event, Emitter<ProfileState> emit) async {
    userRepository.user = userRepository.user.copyWith(name: event.name);
    userRepository.saveUser();
    emit(state.copyWith(user: userRepository.user));
  }
}
