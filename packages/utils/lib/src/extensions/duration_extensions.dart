extension DurationNonNegative on Duration {
  Duration get nonNegative => isNegative ? .zero : this;
}
