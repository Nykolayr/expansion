part of 'update_bloc.dart';

class UpdateState {
  final AllUpgrade upgrade;
  const UpdateState({
    required this.upgrade,
  });

  factory UpdateState.initial() => UpdateState(upgrade: userRepository.upOur);
  UpdateState copyWith({AllUpgrade? upgrade}) =>
      UpdateState(upgrade: upgrade ?? this.upgrade);
}
