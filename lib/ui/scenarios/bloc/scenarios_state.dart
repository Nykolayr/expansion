part of 'scenarios_bloc.dart';

class ScenariosState {
  final List<Base> bases;
  final bool isLoding;
  const ScenariosState({required this.bases, required this.isLoding});
  factory ScenariosState.initial() => const ScenariosState(
        bases: [],
        isLoding: false,
      );
  ScenariosState copyWith({
    List<Base>? bases,
    bool? isLoding,
  }) {
    return ScenariosState(
      bases: bases ?? this.bases,
      isLoding: isLoding ?? this.isLoding,
    );
  }
}
