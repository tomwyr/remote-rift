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

class const Failed() extends McpIntegrationState;
