import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/constants/splash_intro_timing.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_cubit.dart';
import 'package:expansion/presentation/bloc/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._prefs, this._bootstrap, this._guest)
      : super(
          SplashState.initial(
            showIntro: _prefs.getBool(PrefsKeys.splashShowIntro) ?? true,
          ),
        );

  final SharedPreferences _prefs;
  final AppBootstrapCubit _bootstrap;
  final GuestProfileRepository _guest;
  static const int _startCount = 98;

  Completer<void>? _typingDoneCompleter;
  bool _startInProgress = false;
  bool _typingFinishedEarly = false;
  int _introSessionId = 0;

  /// Сброс splash для повторного показа вступления (из настроек).
  Future<void> requestIntroReplay() async {
    await _prefs.setBool(PrefsKeys.splashShowIntro, true);
    _typingDoneCompleter = null;
    _startInProgress = false;
    _typingFinishedEarly = false;
    _introSessionId += 1;
    emit(
      SplashState.initial(
        showIntro: true,
        introSessionId: _introSessionId,
      ),
    );
    AppLog.trace(
      'splash intro replay requested session=$_introSessionId',
      tag: 'Splash',
    );
  }

  Future<void> start({required int introTextLength}) async {
    if (_startInProgress || state.isSuccess) return;
    _startInProgress = true;
    try {
      final showIntro = _prefs.getBool(PrefsKeys.splashShowIntro) ?? true;
      _typingDoneCompleter = Completer<void>();
      if (_typingFinishedEarly) {
        _typingDoneCompleter!.complete();
        _typingFinishedEarly = false;
      }
      emit(
        SplashState.initial(
          showIntro: showIntro,
          introSessionId: _introSessionId,
        ),
      );
      AppLog.trace('splash load start intro=$showIntro', tag: 'Splash');

      final bootstrapFuture = _runBootstrap();

      if (showIntro) {
        await Future.wait<void>([
          bootstrapFuture,
          _runIntroSequence(),
          _runProgressUntil(bootstrapFuture),
        ]);
      } else {
        await _runProgressUntil(bootstrapFuture);
      }

      if (isClosed) return;
      final guest = await _guest.load();
      if (isClosed) return;
      emit(
        state.copyWith(
          isSuccess: true,
          introTypingComplete: true,
          count: 0,
          canContinue: guest.hasCampaignProgress,
        ),
      );
      AppLog.trace(
        'splash load done canContinue=${guest.hasCampaignProgress}',
        tag: 'Splash',
      );
    } finally {
      _startInProgress = false;
    }
  }

  /// Обновить «Продолжить» / большую кнопку после смены прогресса (возврат на splash).
  Future<void> refreshMenuProgress() async {
    if (!state.isSuccess || isClosed) return;
    final guest = await _guest.load();
    if (isClosed) return;
    final canContinue = guest.hasCampaignProgress;
    if (canContinue == state.canContinue) return;
    emit(state.copyWith(canContinue: canContinue));
    AppLog.trace('splash menu refresh canContinue=$canContinue', tag: 'Splash');
  }

  /// Вступление показано — больше не показывать при следующих запусках.
  Future<void> markIntroSeen() async {
    await _prefs.setBool(PrefsKeys.splashShowIntro, false);
    if (isClosed) return;
    emit(state.copyWith(showIntro: false));
    AppLog.trace('splash intro marked seen', tag: 'Splash');
  }

  /// Пропуск вступления: сразу к загрузке, запомнить «уже показали».
  Future<void> skipIntro() async {
    await markIntroSeen();
    markIntroTypingComplete();
    AppLog.trace('splash intro skipped', tag: 'Splash');
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
    } else {
      // Typer закончил до start() (replay под push settings).
      _typingFinishedEarly = true;
    }
    AppLog.trace('splash intro typing complete', tag: 'Splash');
  }

  Future<void> _runIntroSequence() async {
    await _typingDoneCompleter!.future;
    if (isClosed) return;
    if (_prefs.getBool(PrefsKeys.splashShowIntro) ?? false) {
      AppLog.trace('splash intro text done, hold', tag: 'Splash');
      await Future<void>.delayed(
        const Duration(milliseconds: SplashIntroTiming.holdFullTextMs),
      );
    }
  }

  Future<void> _runBootstrap() async {
    try {
      await _bootstrap.initialize();
    } catch (_) {
      AppLog.trace('splash continues after bootstrap error', tag: 'Splash');
    }
  }

  /// Полоса загрузки до завершения [task] (bootstrap + ads + OTA).
  Future<void> _runProgressUntil(Future<void> task) async {
    final startedAt = DateTime.now();
    const tick = Duration(milliseconds: 40);
    var taskDone = false;
    unawaited(
      task.whenComplete(() {
        taskDone = true;
      }),
    );

    while (true) {
      if (isClosed) return;

      if (taskDone) {
        emit(state.copyWith(count: 0));
        return;
      }

      final elapsed = DateTime.now().difference(startedAt);
      final ratio = (elapsed.inMilliseconds /
              SplashIntroTiming.progressAnimationCap.inMilliseconds)
          .clamp(0.0, 0.95);
      final count =
          (_startCount * (1 - ratio)).round().clamp(0, _startCount);
      emit(state.copyWith(count: count));
      await Future<void>.delayed(tick);
    }
  }
}
