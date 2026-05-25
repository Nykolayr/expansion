import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/constants/splash_intro_timing.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/presentation/bloc/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._prefs)
      : super(
          SplashState.initial(
            showIntro: _prefs.getBool(PrefsKeys.splashShowIntro) ?? true,
          ),
        );

  final SharedPreferences _prefs;
  static const int _startCount = 98;

  Completer<void>? _typingDoneCompleter;

  Future<void> start({required int introTextLength}) async {
    final showIntro = _prefs.getBool(PrefsKeys.splashShowIntro) ?? true;
    _typingDoneCompleter = Completer<void>();
    emit(SplashState.initial(showIntro: showIntro));
    AppLog.trace('splash load start intro=$showIntro', tag: 'Splash');

    if (showIntro) {
      await _typingDoneCompleter!.future;
      AppLog.trace('splash intro text done, hold 1s', tag: 'Splash');
      await Future<void>.delayed(
        const Duration(milliseconds: SplashIntroTiming.holdFullTextMs),
      );
      if (isClosed) return;
      await _finishProgressBar();
    } else {
      await _runProgressForDuration(
        const Duration(milliseconds: SplashIntroTiming.skipIntroLoadMs),
      );
    }

    if (isClosed) return;
    emit(
      state.copyWith(
        isSuccess: true,
        introTypingComplete: true,
        count: 0,
      ),
    );
    AppLog.trace('splash load done', tag: 'Splash');
  }

  /// Сохранить выбор галочки «Не показывать при следующей загрузке».
  Future<void> applyIntroPreference({required bool dontShowOnNextLoad}) async {
    if (dontShowOnNextLoad) {
      await _prefs.setBool(PrefsKeys.splashShowIntro, false);
      emit(state.copyWith(showIntro: false));
      AppLog.trace('splash intro disabled for next launch', tag: 'Splash');
    } else {
      await _prefs.setBool(PrefsKeys.splashShowIntro, true);
      AppLog.trace('splash intro enabled for next launch', tag: 'Splash');
    }
  }

  /// Прогресс полосы во время печати (небольшая часть, остальное — в конце).
  void onTypingProgress(int visibleLength, int totalLength) {
    if (totalLength <= 0 || isClosed) return;
    final ratio = visibleLength / totalLength;
    final filledShare = ratio * SplashIntroTiming.typingBarShare;
    final count =
        (_startCount * (1 - filledShare)).round().clamp(0, _startCount);
    emit(state.copyWith(count: count));
  }

  void markIntroTypingComplete() {
    if (_typingDoneCompleter != null && !_typingDoneCompleter!.isCompleted) {
      _typingDoneCompleter!.complete();
    }
    AppLog.trace('splash intro typing complete', tag: 'Splash');
  }

  Future<void> _finishProgressBar() async {
    final fromCount = state.count.clamp(0, _startCount);
    if (fromCount <= 0) {
      emit(state.copyWith(count: 0));
      return;
    }

    final stepMs = (SplashIntroTiming.barFinishMs / fromCount)
        .ceil()
        .clamp(8, 80);

    for (var k = fromCount; k >= 0; k--) {
      if (isClosed) return;
      emit(state.copyWith(count: k));
      if (k > 0) {
        await Future<void>.delayed(Duration(milliseconds: stepMs));
      }
    }
  }

  Future<void> _runProgressForDuration(Duration total) async {
    final startedAt = DateTime.now();
    const tick = Duration(milliseconds: 40);

    while (true) {
      if (isClosed) return;

      final elapsed = DateTime.now().difference(startedAt);
      if (elapsed >= total) {
        emit(state.copyWith(count: 0));
        return;
      }

      final ratio = elapsed.inMilliseconds / total.inMilliseconds;
      final count =
          (_startCount * (1 - ratio)).round().clamp(0, _startCount);
      emit(state.copyWith(count: count));
      await Future<void>.delayed(tick);
    }
  }
}
