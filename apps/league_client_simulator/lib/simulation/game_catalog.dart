import 'package:remote_rift_core/lcu_protocol.dart';

const championNamesById = {
  103: 'Ahri',
  22: 'Ashe',
  51: 'Caitlyn',
  81: 'Ezreal',
  86: 'Garen',
  43: 'Karma',
  64: 'Lee Sin',
  99: 'Lux',
  25: 'Morgana',
  267: 'Nami',
  412: 'Thresh',
  157: 'Yasuo',
};

final champions = [
  for (var MapEntry(:key, :value) in championNamesById.entries)
    ChampGridChampion(id: key, name: value, favorite: key == 103 || key == 99),
];

final spells = [
  SummonerSpell(id: 21, name: 'Barrier', gameModes: ['CLASSIC', 'ARAM']),
  SummonerSpell(id: 3, name: 'Exhaust', gameModes: ['CLASSIC', 'ARAM']),
  SummonerSpell(id: 4, name: 'Flash', gameModes: ['CLASSIC', 'ARAM']),
  SummonerSpell(id: 6, name: 'Ghost', gameModes: ['CLASSIC', 'ARAM']),
  SummonerSpell(id: 7, name: 'Heal', gameModes: ['CLASSIC', 'ARAM']),
  SummonerSpell(id: 14, name: 'Ignite', gameModes: ['CLASSIC', 'ARAM']),
  SummonerSpell(id: 32, name: 'Mark', gameModes: ['ARAM']),
  SummonerSpell(id: 11, name: 'Smite', gameModes: ['CLASSIC']),
  SummonerSpell(id: 12, name: 'Teleport', gameModes: ['CLASSIC']),
];
