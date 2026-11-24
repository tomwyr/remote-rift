import 'package:remote_rift_core/lcu_protocol.dart';

import '../simulator_queue.dart';

extension SimulatorQueueMapper on SimulatorQueue {
  GameQueue toLcuQueue() {
    return GameQueue(
      id: id,
      name: name,
      description: name,
      gameMode: gameMode,
      gameSelectCategory: GameSelectCategory.pvp,
      gameSelectModeGroup: modeGroup,
      isEnabled: true,
      isVisible: true,
      isCustom: false,
    );
  }

  GameflowQueue toLcuGameflowQueue() {
    return GameflowQueue(id: id, name: name, description: name, gameMode: gameMode);
  }
}
