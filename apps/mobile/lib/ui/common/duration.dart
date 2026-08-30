extension DurationSeconds on Duration {
  double get inSecondsDouble => inMicroseconds / Duration.microsecondsPerSecond;
}
