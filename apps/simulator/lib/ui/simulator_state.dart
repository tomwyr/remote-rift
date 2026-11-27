import 'package:equatable/equatable.dart';

import '../simulation/simulator.dart';

typedef SimulatorViewState = ({
  SimulatorConnection connection,
  SimulatorSnapshot session,
});

sealed class SimulatorConnection extends Equatable {
  @override
  List<Object> get props => [];
}

class Initial extends SimulatorConnection;

class Starting extends SimulatorConnection;

class StartFailed({
  required final SimulatorStartupFailure failure,
}) extends SimulatorConnection {
  @override
  List<Object> get props => [failure];
}

enum SimulatorStartupFailure { lockfileUnavailable, listenerUnavailable }

class Listening({
  required final String lockfilePath,
}) extends SimulatorConnection {
  @override
  List<Object> get props => [lockfilePath];
}
