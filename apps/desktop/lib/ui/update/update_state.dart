import 'package:remote_rift_updater/remote_rift_updater.dart';
import 'package:equatable/equatable.dart';

sealed class UpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends UpdateState {}

class UpToDate extends UpdateState {}

class UpdateAvailable({
  required final AvailableUpdate update,
}) extends UpdateState {
  @override
  List<Object?> get props => [update];
}

class UpdateInProgress extends UpdateState {}

class UpdateError({
  required final AvailableUpdate update,
}) extends UpdateState {
  @override
  List<Object?> get props => [update];
}
