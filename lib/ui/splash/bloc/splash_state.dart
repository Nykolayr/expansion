part of 'splash_bloc.dart';

class SplashState {
  final int count;
  final bool isCheck;
  final bool isSuccess;
  SplashState(
      {required this.count, required this.isCheck, required this.isSuccess});

  SplashState copyWith({int? count, bool? isCheck, bool? isSuccess}) {
    return SplashState(
      count: count ?? this.count,
      isCheck: isCheck ?? this.isCheck,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
