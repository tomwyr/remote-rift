/// The maximum age and total size of records retained by a file logger.
///
/// Set [maxAge] and [maxBytes] to positive values.
final class LogConfig({
  final Duration maxAge = const Duration(days: 7),
  final int maxBytes = 2 * 1024 * 1024,
}) {
  this {
    if (maxAge <= .zero) {
      throw ArgumentError.value(maxAge, 'maxAge', 'Must be positive');
    }
    if (maxBytes <= 0) {
      throw ArgumentError.value(maxBytes, 'maxBytes', 'Must be positive');
    }
  }
}
