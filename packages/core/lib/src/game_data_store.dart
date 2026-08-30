import 'lcu/lcu_api_client.dart';
import 'mappers/champion_select.dart';
import 'models/state.dart';

class GameDataStore({
  required final LcuApiClient _lcuApi,
}) {
  Map<int, Champion>? _championsById;
  Map<int, SummonerSpell>? _summonerSpellsById;

  Future<void>? _championsInFlight;
  Future<void>? _summonerSpellsInFlight;

  Future<Champion?> getChampion(int? championId) async {
    if (championId == null || championId <= 0) return null;
    if (_championsById == null) await (_championsInFlight ??= _loadChampions());
    return _championsById?[championId];
  }

  Future<SummonerSpell?> getSummonerSpell(int? spellId) async {
    if (spellId == null || spellId <= 0) return null;
    if (_summonerSpellsById == null) await (_summonerSpellsInFlight ??= _loadSummonerSpells());
    return _summonerSpellsById?[spellId];
  }

  Future<void> _loadChampions() async {
    try {
      final champions = await _lcuApi.getChampGridChampions();
      _championsById = champions.toChampionsById();
    } finally {
      _championsInFlight = null;
    }
  }

  Future<void> _loadSummonerSpells() async {
    try {
      final spells = await _lcuApi.getSummonerSpells();
      _summonerSpellsById = spells.toSummonerSpellsById();
    } finally {
      _summonerSpellsInFlight = null;
    }
  }
}
