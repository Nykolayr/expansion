import 'package:equatable/equatable.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<ChangeUser>(_onChangeUser);
    on<ChangeName>(_onChangeName);
    on<SignOut>(_onSignOut);
  }
  _onSignOut(SignOut event, Emitter<ProfileState> emit) async {
    Get.find<UserRepository>().initUser();
    emit(state.copyWith(user: Get.find<UserRepository>().user));
  }

  _onChangeUser(ChangeUser event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    Get.find<UserRepository>().loadFromBase(event.uid);
    await Get.find<UserRepository>().saveUser();
    emit(state.copyWith(
        user: Get.find<UserRepository>().user, isLoading: false));
  }

  _onChangeName(ChangeName event, Emitter<ProfileState> emit) async {
    Get.find<UserRepository>().user =
        Get.find<UserRepository>().user.copyWith(name: event.name);
    Get.find<UserRepository>().saveUser();
    emit(state.copyWith(user: Get.find<UserRepository>().user));
  }
}
