import '../lcu/lcu_models.dart' as lcu;
import '../models/state.dart';

extension LobbyPositionPreferencesMapper on lcu.LobbyPositionPreferences {
  LobbyRolePreferences? toLobbyRolePreferencesOrNull() {
    return switch ((firstPreference, secondPreference)) {
      (.unselected, .unselected) => const UnselectedLobbyRolePreferences(),
      (.fill, .unselected) || (.fill, .fill) => const FillLobbyRolePreferences(),
      (var first?, var second?) => _toLobbyRoleSelectionOrNull(first, second),
      _ => null,
    };
  }
}

extension LobbyPositionPreferenceMapper on lcu.LobbyPositionPreference {
  LobbyRole? toLobbyRoleOrNull() {
    return switch (this) {
      .top => .top,
      .jungle => .jungle,
      .middle => .middle,
      .bottom => .bottom,
      .utility => .support,
      .unselected || .fill => null,
    };
  }
}

extension LobbyRoleMapper on LobbyRole {
  lcu.LobbyPositionPreference toLcuLobbyPositionPreference() {
    return switch (this) {
      .top => .top,
      .jungle => .jungle,
      .middle => .middle,
      .bottom => .bottom,
      .support => .utility,
    };
  }
}

LobbyRoleSelection? _toLobbyRoleSelectionOrNull(
  lcu.LobbyPositionPreference first,
  lcu.LobbyPositionPreference second,
) {
  final firstRole = first.toLobbyRoleOrNull();
  final secondRole = second.toLobbyRoleOrNull();
  if (firstRole == null || secondRole == null || firstRole == secondRole) return null;

  return LobbyRoleSelection(first: firstRole, second: secondRole);
}
