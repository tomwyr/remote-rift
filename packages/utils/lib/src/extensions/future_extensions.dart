extension FutureRecordExtensions<T1, T2> on (Future<T1>, Future<T2>) {
  Future<(T1, T2)> get waitUnwrapped async {
    late final T1 firstValue;
    late final T2 secondValue;

    await Future.wait<void>([
      $1.then((value) => firstValue = value),
      $2.then((value) => secondValue = value),
    ]);
    return (firstValue, secondValue);
  }
}
