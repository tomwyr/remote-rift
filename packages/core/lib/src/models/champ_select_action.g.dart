// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'champ_select_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChampionSelectChampionInput _$ChampionSelectChampionInputFromJson(
  Map<String, dynamic> json,
) => ChampionSelectChampionInput(
  championId: (json['championId'] as num).toInt(),
  action: $enumDecode(_$ChampionSelectChampionActionEnumMap, json['action']),
);

Map<String, dynamic> _$ChampionSelectChampionInputToJson(
  ChampionSelectChampionInput instance,
) => <String, dynamic>{
  'championId': instance.championId,
  'action': _$ChampionSelectChampionActionEnumMap[instance.action]!,
};

const _$ChampionSelectChampionActionEnumMap = {
  ChampionSelectChampionAction.pick: 'pick',
  ChampionSelectChampionAction.ban: 'ban',
};

ChangeSummonerSpellInput _$ChangeSummonerSpellInputFromJson(
  Map<String, dynamic> json,
) => ChangeSummonerSpellInput(
  spellId: (json['spellId'] as num).toInt(),
  slot: $enumDecode(_$ChampionSelectSummonerSpellSlotEnumMap, json['slot']),
);

Map<String, dynamic> _$ChangeSummonerSpellInputToJson(
  ChangeSummonerSpellInput instance,
) => <String, dynamic>{
  'spellId': instance.spellId,
  'slot': _$ChampionSelectSummonerSpellSlotEnumMap[instance.slot]!,
};

const _$ChampionSelectSummonerSpellSlotEnumMap = {
  ChampionSelectSummonerSpellSlot.first: 'first',
  ChampionSelectSummonerSpellSlot.second: 'second',
};

ChampionSelectCatalog _$ChampionSelectCatalogFromJson(
  Map<String, dynamic> json,
) => ChampionSelectCatalog(
  champions: (json['champions'] as List<dynamic>)
      .map(
        (e) =>
            ChampionSelectCatalogChampion.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  summonerSpells: (json['summonerSpells'] as List<dynamic>)
      .map(
        (e) => ChampionSelectCatalogSummonerSpell.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$ChampionSelectCatalogToJson(
  ChampionSelectCatalog instance,
) => <String, dynamic>{
  'champions': instance.champions,
  'summonerSpells': instance.summonerSpells,
};

ChampionSelectCatalogChampion _$ChampionSelectCatalogChampionFromJson(
  Map<String, dynamic> json,
) => ChampionSelectCatalogChampion(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$ChampionSelectCatalogChampionToJson(
  ChampionSelectCatalogChampion instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

ChampionSelectCatalogSummonerSpell _$ChampionSelectCatalogSummonerSpellFromJson(
  Map<String, dynamic> json,
) => ChampionSelectCatalogSummonerSpell(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$ChampionSelectCatalogSummonerSpellToJson(
  ChampionSelectCatalogSummonerSpell instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

ChampionSelectActionAvailability _$ChampionSelectActionAvailabilityFromJson(
  Map<String, dynamic> json,
) => ChampionSelectActionAvailability(
  pickChampion: json['pickChampion'] as bool,
  banChampion: json['banChampion'] as bool,
  lockInChampion: json['lockInChampion'] as bool,
  changeSummonerSpells: json['changeSummonerSpells'] as bool,
);

Map<String, dynamic> _$ChampionSelectActionAvailabilityToJson(
  ChampionSelectActionAvailability instance,
) => <String, dynamic>{
  'pickChampion': instance.pickChampion,
  'banChampion': instance.banChampion,
  'lockInChampion': instance.lockInChampion,
  'changeSummonerSpells': instance.changeSummonerSpells,
};
