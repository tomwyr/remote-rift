import 'dart:async';
import 'dart:convert';
import 'dart:io';

typedef JsonFileStoreFromJson<T> = T Function(Map<String, dynamic> json);
typedef JsonFileStoreToJson<T> = Map<String, dynamic> Function(T value);

class JsonFileStore<T>({
  required String path,
  required final JsonFileStoreFromJson<T> _fromJson,
  required final JsonFileStoreToJson<T> _toJson,
}) {
  final _file = File(path);
  Future<void>? _operationInFlight;
  T? _value;
  var _loaded = false;

  Future<T?> load() async {
    return await _runSerialized(_load);
  }

  Future<void> save(T value) async {
    await _runSerialized(() async {
      await _write(value);
      _value = value;
      _loaded = true;
    });
  }

  Future<void> clear() async {
    await _runSerialized(() async {
      if (await _file.exists()) {
        await _file.delete();
      }
      _value = null;
      _loaded = true;
    });
  }

  Future<T> update(T Function(T? value) update) async {
    return await _runSerialized(() async {
      final updatedValue = update(await _load());
      await _write(updatedValue);
      _value = updatedValue;
      return updatedValue;
    });
  }

  Future<T?> _load() async {
    if (_loaded) {
      return _value;
    }
    if (!await _file.exists()) {
      _loaded = true;
      return null;
    }

    final contents = await _file.readAsString();
    final json = jsonDecode(contents);
    if (json is! Map<String, dynamic>) {
      throw const FormatException();
    }
    _value = _fromJson(json);
    _loaded = true;
    return _value;
  }

  Future<void> _write(T value) async {
    await _file.parent.create(recursive: true);
    await _file.writeAsString(jsonEncode(_toJson(value)));
  }

  Future<R> _runSerialized<R>(Future<R> Function() operation) async {
    if (_operationInFlight case var inFlight?) {
      await inFlight;
    }

    final result = operation();
    final inFlight = result.then<void>((_) {}, onError: (_, _) {});
    _operationInFlight = inFlight;

    try {
      return await result;
    } finally {
      if (identical(_operationInFlight, inFlight)) {
        _operationInFlight = null;
      }
    }
  }
}
