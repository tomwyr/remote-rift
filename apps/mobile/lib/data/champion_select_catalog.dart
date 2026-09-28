import 'package:remote_rift_core/remote_rift_core.dart';

extension ChampionSelectCatalogSorting on ChampionSelectCatalog {
  ChampionSelectCatalog sorted() {
    final champions = [...this.champions]
      ..sort((first, second) {
        if (first.isFavorite != second.isFavorite) {
          return first.isFavorite ? -1 : 1;
        }
        return first.name.compareTo(second.name);
      });
    final summonerSpells = [...this.summonerSpells]
      ..sort((first, second) => first.name.compareTo(second.name));
    return ChampionSelectCatalog(
      champions: champions,
      summonerSpells: summonerSpells,
    );
  }
}
