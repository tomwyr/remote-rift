// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConnectionErrorCWProxy {
  ConnectionError reconnectTriggered(bool reconnectTriggered);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ConnectionError(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ConnectionError(...).copyWith(id: 12, name: "My name")
  /// ```
  ConnectionError call({bool reconnectTriggered});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfConnectionError.copyWith(...)` or call `instanceOfConnectionError.copyWith.fieldName(value)` for a single field.
class _$ConnectionErrorCWProxyImpl implements _$ConnectionErrorCWProxy {
  const _$ConnectionErrorCWProxyImpl(this._value);

  final ConnectionError _value;

  @override
  ConnectionError reconnectTriggered(bool reconnectTriggered) =>
      call(reconnectTriggered: reconnectTriggered);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ConnectionError(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ConnectionError(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ConnectionError call({
    Object? reconnectTriggered = const $CopyWithPlaceholder(),
  }) {
    return ConnectionError(
      reconnectTriggered:
          reconnectTriggered == const $CopyWithPlaceholder() ||
              reconnectTriggered == null
          ? _value.reconnectTriggered
          // ignore: cast_nullable_to_non_nullable
          : reconnectTriggered as bool,
    );
  }
}

extension $ConnectionErrorCopyWith on ConnectionError {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfConnectionError.copyWith(...)` or `instanceOfConnectionError.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConnectionErrorCWProxy get copyWith => _$ConnectionErrorCWProxyImpl(this);
}
