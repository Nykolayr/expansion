import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  const SplashState({
    required this.count,
    required this.showIntro,
    required this.isSuccess,
    required this.introTypingComplete,
    required this.canContinue,
    this.introSessionId = 0,
  });

  factory SplashState.initial({
    required bool showIntro,
    int introSessionId = 0,
  }) {
    return SplashState(
      count: 100,
      showIntro: showIntro,
      isSuccess: false,
      introTypingComplete: false,
      canContinue: false,
      introSessionId: introSessionId,
    );
  }

  final int count;
  final bool showIntro;
  final bool isSuccess;
  final bool introTypingComplete;

  /// `true` при любом прогрессе кампании — «Продолжить» и нижний ряд меню.
  final bool canContinue;

  /// Увеличивается при повторном показе вступления — remount typer.
  final int introSessionId;

  SplashState copyWith({
    int? count,
    bool? showIntro,
    bool? isSuccess,
    bool? introTypingComplete,
    bool? canContinue,
    int? introSessionId,
  }) {
    return SplashState(
      count: count ?? this.count,
      showIntro: showIntro ?? this.showIntro,
      isSuccess: isSuccess ?? this.isSuccess,
      introTypingComplete: introTypingComplete ?? this.introTypingComplete,
      canContinue: canContinue ?? this.canContinue,
      introSessionId: introSessionId ?? this.introSessionId,
    );
  }

  @override
  List<Object?> get props => [
        count,
        showIntro,
        isSuccess,
        introTypingComplete,
        canContinue,
        introSessionId,
      ];
}
