import 'package:remote_rift_core/lcu_protocol.dart';

enum SimulatorQueue({
  required final int id,
  required final String name,
  required final String gameMode,
  required final String modeGroup,
  required final bool isDraft,
}) {
  draft(
    id: 400,
    name: 'Normal Draft Pick',
    gameMode: 'CLASSIC',
    modeGroup: GameSelectModeGroup.summonersRift,
    isDraft: true,
  ),
  aram(
    id: 450,
    name: 'ARAM',
    gameMode: 'ARAM',
    modeGroup: GameSelectModeGroup.aram,
    isDraft: false,
  ),
}
