// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcp_integration_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$McpIntegrationStateCWProxy {
  McpIntegrationState startsOnLaunch(bool startsOnLaunch);

  McpIntegrationState status(McpIntegrationStatus status);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `McpIntegrationState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// McpIntegrationState(...).copyWith(id: 12, name: "My name")
  /// ```
  McpIntegrationState call({bool startsOnLaunch, McpIntegrationStatus status});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMcpIntegrationState.copyWith(...)` or call `instanceOfMcpIntegrationState.copyWith.fieldName(value)` for a single field.
class _$McpIntegrationStateCWProxyImpl implements _$McpIntegrationStateCWProxy {
  const _$McpIntegrationStateCWProxyImpl(this._value);

  final McpIntegrationState _value;

  @override
  McpIntegrationState startsOnLaunch(bool startsOnLaunch) =>
      call(startsOnLaunch: startsOnLaunch);

  @override
  McpIntegrationState status(McpIntegrationStatus status) =>
      call(status: status);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `McpIntegrationState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// McpIntegrationState(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  McpIntegrationState call({
    Object? startsOnLaunch = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return McpIntegrationState(
      startsOnLaunch:
          startsOnLaunch == const $CopyWithPlaceholder() ||
              startsOnLaunch == null
          ? _value.startsOnLaunch
          // ignore: cast_nullable_to_non_nullable
          : startsOnLaunch as bool,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as McpIntegrationStatus,
    );
  }
}

extension $McpIntegrationStateCopyWith on McpIntegrationState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMcpIntegrationState.copyWith(...)` or `instanceOfMcpIntegrationState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$McpIntegrationStateCWProxy get copyWith =>
      _$McpIntegrationStateCWProxyImpl(this);
}
