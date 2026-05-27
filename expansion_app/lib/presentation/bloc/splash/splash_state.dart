import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  const SplashState({
    required this.count,
    required this.showIntro,
    required this.isSuccess,
    required this.introTypingComplete,
    required this.canContinue,
  });

  factory SplashState.initial({required bool showIntro}) {
    return SplashState(
      count: 100,
      showIntro: showIntro,
      isSuccess: false,
      introTypingComplete: false,
      canContinue: false,
    );
  }

  final int count;
  final bool showIntro;
  final bool isSuccess;
  final bool introTypingComplete;

  /// `true` при любом прогрессе кампании — «Продолжить» и нижний ряд меню.
  final bool canContinue;

  SplashState copyWith({
    int? count,
    bool? showIntro,
    bool? isSuccess,
    bool? introTypingComplete,
    bool? canContinue,
  }) {
    return SplashState(
      count: count ?? this.count,
      showIntro: showIntro ?? this.showIntro,
      isSuccess: isSuccess ?? this.isSuccess,
      introTypingComplete: introTypingComplete ?? this.introTypingComplete,
      canContinue: canContinue ?? this.canContinue,
    );
  }

  @override
  List<Object?> get props =>
      [count, showIntro, isSuccess, introTypingComplete, canContinue];
}
