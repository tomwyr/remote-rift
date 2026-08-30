import 'package:remote_rift_core/remote_rift_core.dart';

import '../i18n/strings.g.dart';

extension RemoteRiftErrorStrings on RemoteRiftError {
  String get title => switch (this) {
    .unableToConnect => t.gameError.unableToConnectTitle,
    .unknown => t.gameError.unknownTitle,
  };

  String get description => switch (this) {
    .unableToConnect => t.gameError.unableToConnectDescription,
    .unknown => t.gameError.unknownDescription,
  };
}

extension GameQueueGroupStrings on GameQueueGroup {
  String get displayName => switch (this) {
    .summonersRift => t.gameQueue.groupLabel.summonersRift,
    .aram => t.gameQueue.groupLabel.aram,
    .alternative => t.gameQueue.groupLabel.alternative,
    .other => t.gameQueue.groupLabel.other,
  };
}

extension ChampionSelectPhaseStrings on ChampionSelectPhase {
  String get displayName => switch (this) {
    .planning => t.championSelect.phase.planning,
    .banPick => t.championSelect.phase.banPick,
    .finalization => t.championSelect.phase.finalization,
  };
}

extension ChampionSelectPositionStrings on ChampionSelectPosition {
  String get displayName => switch (this) {
    .top => t.championSelect.position.top,
    .jungle => t.championSelect.position.jungle,
    .middle => t.championSelect.position.middle,
    .bottom => t.championSelect.position.bottom,
    .support => t.championSelect.position.support,
  };
}

extension LobbyRoleStrings on LobbyRole {
  String get displayName => switch (this) {
    .top => t.lobbyRolePreferences.role.top,
    .jungle => t.lobbyRolePreferences.role.jungle,
    .middle => t.lobbyRolePreferences.role.middle,
    .bottom => t.lobbyRolePreferences.role.bottom,
    .support => t.lobbyRolePreferences.role.support,
  };
}
