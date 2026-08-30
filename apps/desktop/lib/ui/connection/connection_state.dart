import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

part 'connection_state.g.dart';

sealed class ConnectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends ConnectionState;

class Connecting extends ConnectionState;

class Connected extends ConnectionState;

class ConnectedWithError({
  required final RemoteRiftError cause,
}) extends ConnectionState {
  @override
  List<Object?> get props => [cause];
}

@CopyWith()
class ConnectionError({
  final bool reconnectTriggered = false,
}) extends ConnectionState {
  @override
  List<Object?> get props => [reconnectTriggered];
}
