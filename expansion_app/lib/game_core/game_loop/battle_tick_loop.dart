import 'dart:async';
import 'dart:isolate';

import 'package:expansion/game_core/battle/battle_pacing.dart';

/// Команды UI → isolate.
enum _BattleTickCommand {
  stop,
  pause,
  resume,
}

/// Сообщение isolate → UI: очередной тик.
enum _BattleTickSignal {
  tick,
}

/// Источник тиков ~50 FPS в фоновом isolate; симуляция остаётся в [BattleCubit].
class BattleTickLoop {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  StreamSubscription<dynamic>? _subscription;
  SendPort? _controlPort;
  void Function()? _onTick;

  static const Duration tickInterval = BattlePacing.tickInterval;

  Future<void> start(void Function() onTick) async {
    await stop();
    _onTick = onTick;
    _receivePort = ReceivePort();
    final ready = Completer<void>();

    _isolate = await Isolate.spawn(
      _isolateEntry,
      _receivePort!.sendPort,
    );

    _subscription = _receivePort!.listen((message) {
      if (message is SendPort) {
        _controlPort = message;
        if (!ready.isCompleted) ready.complete();
        return;
      }
      if (message == _BattleTickSignal.tick) {
        _onTick?.call();
      }
    });

    await ready.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        throw StateError('BattleTickLoop handshake timeout');
      },
    );
  }

  Future<void> stop() async {
    final control = _controlPort;
    if (control != null) {
      control.send(_BattleTickCommand.stop);
    }
    await _subscription?.cancel();
    _subscription = null;
    _receivePort?.close();
    _receivePort = null;
    _controlPort = null;
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _onTick = null;
  }

  void pause() {
    _controlPort?.send(_BattleTickCommand.pause);
  }

  void resume() {
    _controlPort?.send(_BattleTickCommand.resume);
  }
}

void _isolateEntry(SendPort mainSendPort) {
  final controlReceive = ReceivePort();
  mainSendPort.send(controlReceive.sendPort);

  var running = true;
  var paused = false;
  controlReceive.listen((message) {
    if (message == _BattleTickCommand.stop) {
      running = false;
      controlReceive.close();
    } else if (message == _BattleTickCommand.pause) {
      paused = true;
    } else if (message == _BattleTickCommand.resume) {
      paused = false;
    }
  });

  unawaited(_runLoop(mainSendPort, () => running, () => paused));
}

Future<void> _runLoop(
  SendPort mainSendPort,
  bool Function() isRunning,
  bool Function() isPaused,
) async {
  while (isRunning()) {
    await Future<void>.delayed(BattleTickLoop.tickInterval);
    if (!isRunning()) break;
    if (isPaused()) continue;
    mainSendPort.send(_BattleTickSignal.tick);
  }
}
