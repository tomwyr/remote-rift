import 'package:draft/draft.dart';
import 'package:equatable/equatable.dart';

import '../../i18n/strings.g.dart';

part 'service_state.draft.dart';

sealed class ServiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends ServiceState {}

class Starting extends ServiceState {}

class Started extends ServiceState {}

@draft
class PendingMultipleAddresses extends ServiceState {
  PendingMultipleAddresses({required this.starting});

  final bool starting;

  @override
  List<Object?> get props => [starting];
}

@draft
class StartupError extends ServiceState {
  StartupError({required this.cause, this.restartTriggered = false});

  final ServiceErrorCause cause;
  final bool restartTriggered;

  @override
  List<Object?> get props => [cause, restartTriggered];
}

enum ServiceErrorCause {
  addressNotFound,
  unknown;

  String get description => switch (this) {
    .addressNotFound => t.service.errorNoAddressDescription,
    .unknown => t.service.errorUnknownDescription,
  };
}
