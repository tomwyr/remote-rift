import 'package:remote_rift_utils/remote_rift_utils.dart';

import '../champion_select_state.dart';

sealed class const ChampionSelectPickerEntry();

class const NoChampion() extends ChampionSelectPickerEntry;

class const Section({
  required final ChampionSelectPickerListSection section,
}) extends ChampionSelectPickerEntry;

class const Catalog({
  required final ChampionSelectCatalogEntry entry,
}) extends ChampionSelectPickerEntry;

enum ChampionSelectPickerListSection { favorites, champions }

extension ChampionSelectPickerListEntries on List<ChampionSelectCatalogEntry> {
  List<ChampionSelectPickerEntry> toPickerListEntries({
    required ChampionSelectAction action,
  }) {
    final (favoriteEntries, regularEntries) = splitWhere((entry) => entry.isFavorite);

    return [
      if (action == .banChampion) const NoChampion(),
      if (favoriteEntries.isNotEmpty) const Section(section: .favorites),
      for (final entry in favoriteEntries) Catalog(entry: entry),
      if (favoriteEntries.isNotEmpty && regularEntries.isNotEmpty)
        const Section(section: .champions),
      for (final entry in regularEntries) Catalog(entry: entry),
    ];
  }
}
