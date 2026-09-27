import 'package:remote_rift_core/remote_rift_core.dart';

import '../i18n/strings.g.dart';

enum LobbyRolePreferenceSlot { primary, secondary }

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

extension ChampionSelectStatusStrings on ChampionSelect {
  String get timeLeftLabel => switch (phase) {
    .planning => t.championSelect.status.planning,
    .banPick => turn?.timeLeftLabel ?? t.championSelect.status.waitingForTurn,
    .finalization => t.championSelect.status.finalization,
    .gameStarting => t.championSelect.status.gameStarting,
  };
}

extension ChampionSelectTurnStrings on ChampionSelectTurn {
  String get timeLeftLabel => switch (this) {
    .playerBan => t.championSelect.status.playerBan,
    .playerPick => t.championSelect.status.playerPick,
    .teammateBan => t.championSelect.status.teammateBan,
    .teammatePick => t.championSelect.status.teammatePick,
    .enemyBan => t.championSelect.status.enemyBan,
    .enemyPick => t.championSelect.status.enemyPick,
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
