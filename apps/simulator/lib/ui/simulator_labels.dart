import '../i18n/strings.g.dart';
import '../simulation/simulator_queue.dart';
import '../simulation/simulator_stage.dart';
import 'simulator_state.dart';

extension SimulatorQueueLabel on SimulatorQueue {
  String get localizedName => switch (this) {
    .draft => t.queues.draft,
    .aram => t.queues.aram,
  };
}

extension SimulatorStageLabel on SimulatorStage {
  String get localizedName => switch (this) {
    .home => t.session.stages.home,
    .lobby => t.session.stages.lobby,
    .searching => t.session.stages.searching,
    .readyCheck => t.session.stages.readyCheck,
    .planning => t.session.stages.planning,
    .localBan => t.session.stages.localBan,
    .enemyBan => t.session.stages.enemyBan,
    .teammatePick => t.session.stages.teammatePick,
    .enemyPick => t.session.stages.enemyPick,
    .localPick => t.session.stages.localPick,
    .finalization => t.session.stages.finalization,
    .gameStarting => t.session.stages.gameStarting,
    .inGame => t.session.stages.inGame,
    .waitingForStats => t.session.stages.waitingForStats,
    .preEndOfGame => t.session.stages.preEndOfGame,
    .endOfGame => t.session.stages.endOfGame,
  };
}

extension SimulatorStartupFailureLabel on SimulatorStartupFailure {
  String get localizedDescription => switch (this) {
    .lockfileUnavailable => t.connection.lockfileUnavailable,
    .listenerUnavailable => t.connection.listenerUnavailable,
  };
}
