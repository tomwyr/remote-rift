import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'champ_select_action.g.dart';

enum ChampionSelectActionType {
  pickChampion,
  banChampion,
  lockInChampion,
  changeSummonerSpells,
}

enum ChampionSelectSummonerSpellSlot { first, second }

@JsonSerializable()
class ChampionSelectChampionInput({
  required final int championId,
  required final ChampionSelectChampionAction action,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ChampionSelectChampionInputFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionSelectChampionInputToJson(this);
}

enum ChampionSelectChampionAction { pick, ban }

@JsonSerializable()
class ChangeSummonerSpellInput({
  required final int spellId,
  required final ChampionSelectSummonerSpellSlot slot,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ChangeSummonerSpellInputFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeSummonerSpellInputToJson(this);
}

@JsonSerializable()
class const ChampionSelectCatalog({
  required final List<ChampionSelectCatalogChampion> champions,
  required final List<ChampionSelectCatalogSummonerSpell> summonerSpells,
}) extends Equatable {
  factory fromJson(Map<String, dynamic> json) => _$ChampionSelectCatalogFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionSelectCatalogToJson(this);

  @override
  List<Object?> get props => [champions, summonerSpells];
}

@JsonSerializable()
class const ChampionSelectCatalogChampion({
  required final int id,
  required final String name,
}) extends Equatable {
  factory fromJson(Map<String, dynamic> json) => _$ChampionSelectCatalogChampionFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionSelectCatalogChampionToJson(this);

  @override
  List<Object?> get props => [id, name];
}

@JsonSerializable()
class const ChampionSelectCatalogSummonerSpell({
  required final int id,
  required final String name,
}) extends Equatable {
  factory fromJson(Map<String, dynamic> json) => _$ChampionSelectCatalogSummonerSpellFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionSelectCatalogSummonerSpellToJson(this);

  @override
  List<Object?> get props => [id, name];
}

@JsonSerializable()
class const ChampionSelectActionAvailability({
  required final bool pickChampion,
  required final bool banChampion,
  required final bool lockInChampion,
  required final bool changeSummonerSpells,
}) extends Equatable {
  static const pick = ChampionSelectActionAvailability(
    pickChampion: true,
    banChampion: false,
    lockInChampion: true,
    changeSummonerSpells: true,
  );

  static const ban = ChampionSelectActionAvailability(
    pickChampion: false,
    banChampion: true,
    lockInChampion: false,
    changeSummonerSpells: false,
  );

  static const unavailable = ChampionSelectActionAvailability(
    pickChampion: false,
    banChampion: false,
    lockInChampion: false,
    changeSummonerSpells: false,
  );

  factory fromJson(Map<String, dynamic> json) => _$ChampionSelectActionAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionSelectActionAvailabilityToJson(this);

  bool allows(ChampionSelectActionType action) {
    return switch (action) {
      .pickChampion => pickChampion,
      .banChampion => banChampion,
      .lockInChampion => lockInChampion,
      .changeSummonerSpells => changeSummonerSpells,
    };
  }

  @override
  List<Object?> get props => [pickChampion, banChampion, lockInChampion, changeSummonerSpells];
}
