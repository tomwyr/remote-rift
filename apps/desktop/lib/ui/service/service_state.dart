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
class StartupError({
  required final ServiceErrorCause cause,
  final bool restartTriggered = false,
}) extends ServiceState {
  @override
  List<Object?> get props => [cause, restartTriggered];
}

enum ServiceErrorCause {
  unknown;

  String get description => switch (this) {
    .unknown => t.service.errorUnknownDescription,
  };
}
