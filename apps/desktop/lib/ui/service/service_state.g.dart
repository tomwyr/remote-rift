// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StartupErrorCWProxy {
  StartupError cause(ServiceErrorCause cause);

  StartupError restartTriggered(bool restartTriggered);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `StartupError(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// StartupError(...).copyWith(id: 12, name: "My name")
  /// ```
  StartupError call({ServiceErrorCause cause, bool restartTriggered});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfStartupError.copyWith(...)` or call `instanceOfStartupError.copyWith.fieldName(value)` for a single field.
class _$StartupErrorCWProxyImpl implements _$StartupErrorCWProxy {
  const _$StartupErrorCWProxyImpl(this._value);

  final StartupError _value;

  @override
  StartupError cause(ServiceErrorCause cause) => call(cause: cause);

  @override
  StartupError restartTriggered(bool restartTriggered) =>
      call(restartTriggered: restartTriggered);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `StartupError(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// StartupError(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  StartupError call({
    Object? cause = const $CopyWithPlaceholder(),
    Object? restartTriggered = const $CopyWithPlaceholder(),
  }) {
    return StartupError(
      cause: cause == const $CopyWithPlaceholder() || cause == null
          ? _value.cause
          // ignore: cast_nullable_to_non_nullable
          : cause as ServiceErrorCause,
      restartTriggered:
          restartTriggered == const $CopyWithPlaceholder() ||
              restartTriggered == null
          ? _value.restartTriggered
          // ignore: cast_nullable_to_non_nullable
          : restartTriggered as bool,
    );
  }
}

extension $StartupErrorCopyWith on StartupError {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfStartupError.copyWith(...)` or `instanceOfStartupError.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StartupErrorCWProxy get copyWith => _$StartupErrorCWProxyImpl(this);
}
