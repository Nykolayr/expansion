import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  const SplashState({
    required this.count,
    required this.showIntro,
    required this.isSuccess,
    required this.introTypingComplete,
  });

  factory SplashState.initial({required bool showIntro}) {
    return SplashState(
      count: 100,
      showIntro: showIntro,
      isSuccess: false,
      introTypingComplete: false,
    );
  }

  final int count;
  final bool showIntro;
  final bool isSuccess;
  final bool introTypingComplete;

  SplashState copyWith({
    int? count,
    bool? showIntro,
    bool? isSuccess,
    bool? introTypingComplete,
  }) {
    return SplashState(
      count: count ?? this.count,
      showIntro: showIntro ?? this.showIntro,
      isSuccess: isSuccess ?? this.isSuccess,
      introTypingComplete: introTypingComplete ?? this.introTypingComplete,
    );
  }

  @override
  List<Object?> get props =>
      [count, showIntro, isSuccess, introTypingComplete];
}
