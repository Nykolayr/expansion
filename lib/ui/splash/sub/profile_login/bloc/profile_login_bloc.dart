import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_login_event.dart';
part 'profile_login_state.dart';

class ProfileLoginBloc extends Bloc<ProfileLoginEvent, ProfileLoginState> {
  ProfileLoginBloc() : super(ProfileInitial());
}
