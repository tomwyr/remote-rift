extension MapExtensions<K, V> on Map<K, V> {
  Iterable<(K, V)> get records sync* {
    for (var key in keys) {
      yield (key, this[key]!);
    }
  }

  Map<K, T> mapValues<T>(T Function(V value) mapper) {
    return {for (var entry in entries) entry.key: mapper(entry.value)};
  }
}
