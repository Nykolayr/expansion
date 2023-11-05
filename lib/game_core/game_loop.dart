import 'dart:isolate';

bool _running = true;

Future<void> mainLoop(SendPort sendPort) async {
  const fps = 50;
  const second = 1000;
  const updateTime = second / fps;
  // ignore: unused_local_variable
  var updates = 0;

  final loopWatch = Stopwatch()..start();

  final timerWatch = Stopwatch()..start();

  while (_running) {
    if (loopWatch.elapsedMilliseconds > updateTime) {
      updates++;
      loopWatch.reset();
      sendPort.send(true);
    }

    if (timerWatch.elapsedMilliseconds > second) {
      // print("${DateTime.now()} FPS: $updates");
      updates = 0;
      timerWatch.reset();
    }
  }
}

void stopLoop() {
  _running = false;
}
