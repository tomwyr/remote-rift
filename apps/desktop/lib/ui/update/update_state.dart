import 'package:equatable/equatable.dart';
import 'package:remote_rift_updater/remote_rift_updater.dart';

sealed class UpdateState extends Equatable {
  bool get canRetry => false;

  @override
  List<Object?> get props => [];
}

class Initial extends UpdateState;

class UpToDate extends UpdateState;

class UpdateCheckFailed extends UpdateState;

class UpdateAvailable({required final UpdateRelease update}) extends UpdateState {
  @override
  List<Object?> get props => [update];
}

class UpdateInProgress extends UpdateState;

class UpdateError({required final UpdateRelease update}) extends UpdateState {
  @override
  bool get canRetry => true;

  @override
  List<Object?> get props => [update];
}
