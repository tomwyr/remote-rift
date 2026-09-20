import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'mcp_integration_state.g.dart';

@CopyWith()
class McpIntegrationState({
  required final bool startsOnLaunch,
  required final McpIntegrationStatus status,
}) extends Equatable {
  @override
  List<Object?> get props => [startsOnLaunch, status];
}

sealed class const McpIntegrationStatus() extends Equatable {
  @override
  List<Object?> get props => [];
}

class const Idle() extends McpIntegrationStatus;

class const Starting() extends McpIntegrationStatus;

class Running({required final String hostConfiguration}) extends McpIntegrationStatus {
  @override
  List<Object?> get props => [hostConfiguration];
}

class Stopped({required final Running lastRunningState}) extends McpIntegrationStatus {
  @override
  List<Object?> get props => [lastRunningState];
}

class Resetting({required final Running lastRunningState}) extends McpIntegrationStatus {
  @override
  List<Object?> get props => [lastRunningState];
}

enum McpAction { start, reset, stop, configuration }

class Failed({required final McpAction action}) extends McpIntegrationStatus {
  @override
  List<Object?> get props => [action];
}

enum McpIntegrationEvent { stopped }
