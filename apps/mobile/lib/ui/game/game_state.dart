import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

part 'game_state.g.dart';

sealed class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends GameState;

@CopyWith()
class Data({
  required final String? queueName,
  required final RemoteRiftState state,
  final bool loading = false,
}) extends GameState {
  @override
  List<Object?> get props => [queueName, state, loading];
}
