extension IterableExtensions<T> on Iterable<T> {
  Map<K, List<T>> groupedBy<K>(K Function(T value) keyOf) {
    final result = <K, List<T>>{};
    for (var value in this) {
      result.putIfAbsent(keyOf(value), () => []).add(value);
    }
    return result;
  }

  List<T> orderedBy<C extends Comparable>(
    C Function(T value) comparableOf, {
    IterableOrder order = .asc,
  }) {
    final comparables = <T, C>{};

    compare(T a, T b) {
      final compA = comparables.putIfAbsent(a, () => comparableOf(a));
      final compB = comparables.putIfAbsent(b, () => comparableOf(b));
      return compA.compareTo(compB);
    }

    return toList()..sort(
      (a, b) => switch (order) {
        .asc => compare(a, b),
        .desc => compare(b, a),
      },
    );
  }
}

enum IterableOrder { asc, desc }
