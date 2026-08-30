// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'champion_select_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DataCWProxy {
  Data championSelect(ChampionSelect championSelect);

  Data catalog(ChampionSelectCatalog catalog);

  Data actionStatuses(
    Map<ChampionSelectAction, ChampionSelectActionStatus> actionStatuses,
  );

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Data(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Data(...).copyWith(id: 12, name: "My name")
  /// ```
  Data call({
    ChampionSelect championSelect,
    ChampionSelectCatalog catalog,
    Map<ChampionSelectAction, ChampionSelectActionStatus> actionStatuses,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfData.copyWith(...)` or call `instanceOfData.copyWith.fieldName(value)` for a single field.
class _$DataCWProxyImpl implements _$DataCWProxy {
  const _$DataCWProxyImpl(this._value);

  final Data _value;

  @override
  Data championSelect(ChampionSelect championSelect) =>
      call(championSelect: championSelect);

  @override
  Data catalog(ChampionSelectCatalog catalog) => call(catalog: catalog);

  @override
  Data actionStatuses(
    Map<ChampionSelectAction, ChampionSelectActionStatus> actionStatuses,
  ) => call(actionStatuses: actionStatuses);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Data(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Data(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  Data call({
    Object? championSelect = const $CopyWithPlaceholder(),
    Object? catalog = const $CopyWithPlaceholder(),
    Object? actionStatuses = const $CopyWithPlaceholder(),
  }) {
    return Data(
      championSelect:
          championSelect == const $CopyWithPlaceholder() ||
              championSelect == null
          ? _value.championSelect
          // ignore: cast_nullable_to_non_nullable
          : championSelect as ChampionSelect,
      catalog: catalog == const $CopyWithPlaceholder() || catalog == null
          ? _value.catalog
          // ignore: cast_nullable_to_non_nullable
          : catalog as ChampionSelectCatalog,
      actionStatuses:
          actionStatuses == const $CopyWithPlaceholder() ||
              actionStatuses == null
          ? _value.actionStatuses
          // ignore: cast_nullable_to_non_nullable
          : actionStatuses
                as Map<ChampionSelectAction, ChampionSelectActionStatus>,
    );
  }
}

extension $DataCopyWith on Data {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfData.copyWith(...)` or `instanceOfData.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DataCWProxy get copyWith => _$DataCWProxyImpl(this);
}
