bool _running = true;

void startLoop() {
  const double fps = 50;

  const double updateTime = 1000 / fps;

  Stopwatch loopWatch = Stopwatch();
  loopWatch.start();
  Stopwatch timerWatch = Stopwatch();
  timerWatch.start();

  while (_running) {
    if (loopWatch.elapsedMilliseconds > updateTime) {
      loopWatch.reset();
    }
  }
}

void stopLoop() {
  _running = false;
}
