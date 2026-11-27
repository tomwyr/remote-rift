import 'package:remote_rift_core/lcu_protocol.dart';
import 'package:time/time.dart';

enum SimulatorStage(final GameflowPhase gameflowPhase) {
  home(.none),
  lobby(.lobby),
  searching(.matchmaking),
  readyCheck(.readyCheck),
  planning(.champSelect),
  localBan(.champSelect),
  enemyBan(.champSelect),
  teammatePick(.champSelect),
  enemyPick(.champSelect),
  localPick(.champSelect),
  finalization(.champSelect),
  gameStarting(.champSelect),
  inGame(.inProgress),
  waitingForStats(.waitingForStats),
  preEndOfGame(.preEndOfGame),
  endOfGame(.endOfGame);

  Duration? get duration => switch (this) {
    .home || .lobby => null,
    .searching => 6.seconds,
    .readyCheck => 10.seconds,
    .planning => 18.seconds,
    .localBan => 30.seconds,
    .enemyBan || .teammatePick || .enemyPick => 3.seconds,
    .localPick => 40.seconds,
    .finalization => 10.seconds,
    .gameStarting => 3.seconds,
    .inGame => 30.seconds,
    .waitingForStats || .preEndOfGame => 2.seconds,
    .endOfGame => 3.seconds,
  };

  ChampSelectTimerPhase? get championSelectPhase => switch (this) {
    .planning => .planning,
    .localBan || .enemyBan || .teammatePick || .enemyPick || .localPick => .banPick,
    .finalization => .finalization,
    .gameStarting => .gameStarting,
    _ => null,
  };
}
