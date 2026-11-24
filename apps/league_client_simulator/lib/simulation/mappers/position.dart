import 'package:remote_rift_core/lcu_protocol.dart';

extension LobbyPositionPreferenceMapper on LobbyPositionPreference {
  ChampSelectAssignedPosition toLcuAssignedPosition() => switch (this) {
    .top => .top,
    .jungle => .jungle,
    .bottom => .bottom,
    .utility => .utility,
    .middle || .fill || .unselected => .middle,
  };
}
