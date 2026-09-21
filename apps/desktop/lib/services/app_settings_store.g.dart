// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_store.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppSettingsCWProxy {
  AppSettings startsOnLaunch(bool startsOnLaunch);

  AppSettings customLockfilePath(String? customLockfilePath);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AppSettings(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AppSettings(...).copyWith(id: 12, name: "My name")
  /// ```
  AppSettings call({bool startsOnLaunch, String? customLockfilePath});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAppSettings.copyWith(...)` or call `instanceOfAppSettings.copyWith.fieldName(value)` for a single field.
class _$AppSettingsCWProxyImpl implements _$AppSettingsCWProxy {
  const _$AppSettingsCWProxyImpl(this._value);

  final AppSettings _value;

  @override
  AppSettings startsOnLaunch(bool startsOnLaunch) =>
      call(startsOnLaunch: startsOnLaunch);

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
    Object? startsOnLaunch = const $CopyWithPlaceholder(),
    Object? customLockfilePath = const $CopyWithPlaceholder(),
  }) {
    return AppSettings(
      startsOnLaunch:
          startsOnLaunch == const $CopyWithPlaceholder() ||
              startsOnLaunch == null
          ? _value.startsOnLaunch
          // ignore: cast_nullable_to_non_nullable
          : startsOnLaunch as bool,
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
  startsOnLaunch: json['startsOnLaunch'] as bool,
  customLockfilePath: json['customLockfilePath'] as String?,
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'startsOnLaunch': instance.startsOnLaunch,
      'customLockfilePath': instance.customLockfilePath,
    };
