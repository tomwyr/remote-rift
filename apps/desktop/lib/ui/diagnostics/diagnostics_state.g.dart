// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnostics_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LoadedCWProxy {
  Loaded captureEnabled(bool captureEnabled);

  Loaded storageStatus(LogStorageStatus storageStatus);

  Loaded actions(DiagnosticsActions actions);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Loaded(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Loaded(...).copyWith(id: 12, name: "My name")
  /// ```
  Loaded call({
    bool captureEnabled,
    LogStorageStatus storageStatus,
    DiagnosticsActions actions,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLoaded.copyWith(...)` or call `instanceOfLoaded.copyWith.fieldName(value)` for a single field.
class _$LoadedCWProxyImpl implements _$LoadedCWProxy {
  const _$LoadedCWProxyImpl(this._value);

  final Loaded _value;

  @override
  Loaded captureEnabled(bool captureEnabled) =>
      call(captureEnabled: captureEnabled);

  @override
  Loaded storageStatus(LogStorageStatus storageStatus) =>
      call(storageStatus: storageStatus);

  @override
  Loaded actions(DiagnosticsActions actions) => call(actions: actions);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Loaded(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Loaded(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  Loaded call({
    Object? captureEnabled = const $CopyWithPlaceholder(),
    Object? storageStatus = const $CopyWithPlaceholder(),
    Object? actions = const $CopyWithPlaceholder(),
  }) {
    return Loaded(
      captureEnabled:
          captureEnabled == const $CopyWithPlaceholder() ||
              captureEnabled == null
          ? _value.captureEnabled
          // ignore: cast_nullable_to_non_nullable
          : captureEnabled as bool,
      storageStatus:
          storageStatus == const $CopyWithPlaceholder() || storageStatus == null
          ? _value.storageStatus
          // ignore: cast_nullable_to_non_nullable
          : storageStatus as LogStorageStatus,
      actions: actions == const $CopyWithPlaceholder() || actions == null
          ? _value.actions
          // ignore: cast_nullable_to_non_nullable
          : actions as DiagnosticsActions,
    );
  }
}

extension $LoadedCopyWith on Loaded {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLoaded.copyWith(...)` or `instanceOfLoaded.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LoadedCWProxy get copyWith => _$LoadedCWProxyImpl(this);
}

abstract class _$DiagnosticsActionsCWProxy {
  DiagnosticsActions loadPreference(DiagnosticsActionStatus loadPreference);

  DiagnosticsActions savePreference(DiagnosticsActionStatus savePreference);

  DiagnosticsActions clearLogs(DiagnosticsActionStatus clearLogs);

  DiagnosticsActions exportLogs(LogExportStatus exportLogs);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `DiagnosticsActions(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DiagnosticsActions(...).copyWith(id: 12, name: "My name")
  /// ```
  DiagnosticsActions call({
    DiagnosticsActionStatus loadPreference,
    DiagnosticsActionStatus savePreference,
    DiagnosticsActionStatus clearLogs,
    LogExportStatus exportLogs,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfDiagnosticsActions.copyWith(...)` or call `instanceOfDiagnosticsActions.copyWith.fieldName(value)` for a single field.
class _$DiagnosticsActionsCWProxyImpl implements _$DiagnosticsActionsCWProxy {
  const _$DiagnosticsActionsCWProxyImpl(this._value);

  final DiagnosticsActions _value;

  @override
  DiagnosticsActions loadPreference(DiagnosticsActionStatus loadPreference) =>
      call(loadPreference: loadPreference);

  @override
  DiagnosticsActions savePreference(DiagnosticsActionStatus savePreference) =>
      call(savePreference: savePreference);

  @override
  DiagnosticsActions clearLogs(DiagnosticsActionStatus clearLogs) =>
      call(clearLogs: clearLogs);

  @override
  DiagnosticsActions exportLogs(LogExportStatus exportLogs) =>
      call(exportLogs: exportLogs);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `DiagnosticsActions(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DiagnosticsActions(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  DiagnosticsActions call({
    Object? loadPreference = const $CopyWithPlaceholder(),
    Object? savePreference = const $CopyWithPlaceholder(),
    Object? clearLogs = const $CopyWithPlaceholder(),
    Object? exportLogs = const $CopyWithPlaceholder(),
  }) {
    return DiagnosticsActions(
      loadPreference:
          loadPreference == const $CopyWithPlaceholder() ||
              loadPreference == null
          ? _value.loadPreference
          // ignore: cast_nullable_to_non_nullable
          : loadPreference as DiagnosticsActionStatus,
      savePreference:
          savePreference == const $CopyWithPlaceholder() ||
              savePreference == null
          ? _value.savePreference
          // ignore: cast_nullable_to_non_nullable
          : savePreference as DiagnosticsActionStatus,
      clearLogs: clearLogs == const $CopyWithPlaceholder() || clearLogs == null
          ? _value.clearLogs
          // ignore: cast_nullable_to_non_nullable
          : clearLogs as DiagnosticsActionStatus,
      exportLogs:
          exportLogs == const $CopyWithPlaceholder() || exportLogs == null
          ? _value.exportLogs
          // ignore: cast_nullable_to_non_nullable
          : exportLogs as LogExportStatus,
    );
  }
}

extension $DiagnosticsActionsCopyWith on DiagnosticsActions {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfDiagnosticsActions.copyWith(...)` or `instanceOfDiagnosticsActions.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DiagnosticsActionsCWProxy get copyWith =>
      _$DiagnosticsActionsCWProxyImpl(this);
}
