import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import '../../i18n/strings.g.dart';

part 'connection_state.g.dart';

sealed class ConnectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends ConnectionState;

class Connecting extends ConnectionState;

class Connected extends ConnectionState;

class ConnectedIncompatible({
  required final ConnectionIncompatibility cause,
}) extends ConnectionState {
  @override
  List<Object?> get props => [cause];
}

class ConnectedWithError({
  required final RemoteRiftError cause,
}) extends ConnectionState {
  @override
  List<Object?> get props => [cause];
}

@CopyWith()
class ConnectionError({
  required final ConnectionErrorCause cause,
  final bool reconnectTriggered = false,
}) extends ConnectionState {
  @override
  List<Object?> get props => [cause, reconnectTriggered];
}

extension ConnectionStateStrings on ConnectionState {
  String get statusLabel => switch (this) {
    Connected() => t.connection.statusReady,
    Connecting() || Initial() => t.connection.statusConnecting,
    _ => t.connection.statusCheck,
  };
}

enum ConnectionIncompatibility { apiVersionTooLow }

enum ConnectionErrorCause {
  serviceNotFound,
  connectionLost,
  unknown;

  String get description => switch (this) {
    .serviceNotFound || .connectionLost => t.connection.errorUnableToConnectDescription,
    .unknown => t.connection.errorUnknownDescription,
  };
}
