part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState(this.count);
  final int count;

  @override
  List<Object> get props => [count];
}

class SplashInitial extends SplashState {
  const SplashInitial() : super(100);
}

class SplashIsLoad extends SplashState {
  const SplashIsLoad(super.count);
  factory SplashIsLoad.copyWith(int count) {
    return SplashIsLoad(count);
  }
}

class SplashLoadSucsess extends SplashState {
  const SplashLoadSucsess() : super(0);
}

class SplashLoadError extends SplashState {
  const SplashLoadError(super.count);
}