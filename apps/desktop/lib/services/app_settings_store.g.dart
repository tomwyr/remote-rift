// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_store.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppSettingsCWProxy {
  AppSettings mcpPreviouslyEnabled(bool mcpPreviouslyEnabled);

  AppSettings mcpStartsOnLaunch(bool mcpStartsOnLaunch);

  AppSettings customLockfilePath(String? customLockfilePath);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AppSettings(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AppSettings(...).copyWith(id: 12, name: "My name")
  /// ```
  AppSettings call({
    bool mcpPreviouslyEnabled,
    bool mcpStartsOnLaunch,
    String? customLockfilePath,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAppSettings.copyWith(...)` or call `instanceOfAppSettings.copyWith.fieldName(value)` for a single field.
class _$AppSettingsCWProxyImpl implements _$AppSettingsCWProxy {
  const _$AppSettingsCWProxyImpl(this._value);

  final AppSettings _value;

  @override
  AppSettings mcpPreviouslyEnabled(bool mcpPreviouslyEnabled) =>
      call(mcpPreviouslyEnabled: mcpPreviouslyEnabled);

  @override
  AppSettings mcpStartsOnLaunch(bool mcpStartsOnLaunch) =>
      call(mcpStartsOnLaunch: mcpStartsOnLaunch);

  @override
  AppSettings customLockfilePath(String? customLockfilePath) =>
      call(customLockfilePath: customLockfilePath);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AppSettings(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AppSettings(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AppSettings call({
    Object? mcpPreviouslyEnabled = const $CopyWithPlaceholder(),
    Object? mcpStartsOnLaunch = const $CopyWithPlaceholder(),
    Object? customLockfilePath = const $CopyWithPlaceholder(),
  }) {
    return AppSettings(
      mcpPreviouslyEnabled:
          mcpPreviouslyEnabled == const $CopyWithPlaceholder() ||
              mcpPreviouslyEnabled == null
          ? _value.mcpPreviouslyEnabled
          // ignore: cast_nullable_to_non_nullable
          : mcpPreviouslyEnabled as bool,
      mcpStartsOnLaunch:
          mcpStartsOnLaunch == const $CopyWithPlaceholder() ||
              mcpStartsOnLaunch == null
          ? _value.mcpStartsOnLaunch
          // ignore: cast_nullable_to_non_nullable
          : mcpStartsOnLaunch as bool,
      customLockfilePath: customLockfilePath == const $CopyWithPlaceholder()
          ? _value.customLockfilePath
          // ignore: cast_nullable_to_non_nullable
          : customLockfilePath as String?,
    );
  }
}

extension $AppSettingsCopyWith on AppSettings {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAppSettings.copyWith(...)` or `instanceOfAppSettings.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppSettingsCWProxy get copyWith => _$AppSettingsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  mcpPreviouslyEnabled: json['mcpPreviouslyEnabled'] as bool,
  mcpStartsOnLaunch: json['mcpStartsOnLaunch'] as bool,
  customLockfilePath: json['customLockfilePath'] as String?,
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'mcpPreviouslyEnabled': instance.mcpPreviouslyEnabled,
      'mcpStartsOnLaunch': instance.mcpStartsOnLaunch,
      'customLockfilePath': instance.customLockfilePath,
    };
