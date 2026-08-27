// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DataCWProxy {
  Data queueName(String? queueName);

  Data state(RemoteRiftState state);

  Data loading(bool loading);


  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Data(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Data(...).copyWith(id: 12, name: "My name")
  /// ```
  Data call({
    String? queueName,
    RemoteRiftState state,
    bool loading,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfData.copyWith(...)` or call `instanceOfData.copyWith.fieldName(value)` for a single field.
class _$DataCWProxyImpl implements _$DataCWProxy {
  const _$DataCWProxyImpl(this._value);

  final Data _value;

  @override
  Data queueName(String? queueName) => call(queueName: queueName);

  @override
  Data state(RemoteRiftState state) => call(state: state);

  @override
  Data loading(bool loading) => call(loading: loading);


  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Data(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Data(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  Data call({
    Object? queueName = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
    Object? loading = const $CopyWithPlaceholder(),
  }) {
    return Data(
      queueName: queueName == const $CopyWithPlaceholder()
          ? _value.queueName
          // ignore: cast_nullable_to_non_nullable
          : queueName as String?,
      state: state == const $CopyWithPlaceholder() || state == null
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as RemoteRiftState,
      loading: loading == const $CopyWithPlaceholder() || loading == null
          ? _value.loading
          // ignore: cast_nullable_to_non_nullable
          : loading as bool,
    );
  }
}

extension $DataCopyWith on Data {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfData.copyWith(...)` or `instanceOfData.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DataCWProxy get copyWith => _$DataCWProxyImpl(this);
}
