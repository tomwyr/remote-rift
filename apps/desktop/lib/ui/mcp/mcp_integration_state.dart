import 'package:equatable/equatable.dart';

sealed class const McpIntegrationState() extends Equatable {
  @override
  List<Object?> get props => [];
}

class const Idle() extends McpIntegrationState;

class const Starting() extends McpIntegrationState;

class Running({
  required final String hostConfiguration,
}) extends McpIntegrationState {
  @override
  List<Object?> get props => [...super.props, hostConfiguration];
}

class Stopped({required final Running lastRunningState}) extends McpIntegrationState {
  @override
  List<Object?> get props => [...super.props, lastRunningState];
}

enum McpAction { start, reset, stop }

class Failed({required final McpAction action}) extends McpIntegrationState {
  @override
  List<Object?> get props => [...super.props, action];
}

enum McpIntegrationEvent { stopped }
