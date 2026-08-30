import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

part 'game_state.g.dart';

sealed class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends GameState;

enum GameAction {
  createLobby,
  searchMatch,
  leaveLobby,
  updateRoles,
  stopSearch,
  acceptMatch,
  declineMatch,
}

@CopyWith()
class Data({
  required final String? queueName,
  required final RemoteRiftState state,
  final bool loading = false,
  final GameAction? failedAction,
}) extends GameState {
  @override
  List<Object?> get props => [queueName, state, loading, failedAction];

  bool get canRetry {
    final state = this.state;
    switch (failedAction) {
      case .createLobby:
        return state is PreGame;
      case .searchMatch || .leaveLobby || .updateRoles:
        return state is Lobby && state.state == .idle;
      case .stopSearch:
        return state is Lobby && state.state == .searching;
      case .acceptMatch || .declineMatch:
        return state is Found && state.state == .pending;
      case null:
        return false;
    }
  }
}
