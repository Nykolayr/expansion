import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_register_event.dart';
part 'profile_register_state.dart';

class ProfileRegisterBloc
    extends Bloc<ProfileRegisterEvent, ProfileRegisterState> {
  ProfileRegisterBloc() : super(ProfileInitial());
}
