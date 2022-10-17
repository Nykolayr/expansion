import 'dart:isolate';

bool _running = true;

void mainLoop(SendPort sendPort) async {
  const double fps = 50;
  const double second = 1000;
  const double updateTime = second / fps;
  // ignore: unused_local_variable
  double updates = 0;

  Stopwatch loopWatch = Stopwatch();
  loopWatch.start();
  Stopwatch timerWatch = Stopwatch();
  timerWatch.start();

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
