import 'package:application_updater/application_updater.dart';
import 'package:equatable/equatable.dart';

sealed class UpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends UpdateState {}

class UpToDate extends UpdateState {}

class UpdateAvailable extends UpdateState {
  UpdateAvailable({required this.update});

  final AvailableUpdate update;

  @override
  List<Object?> get props => [update];
}

class UpdateInProgress extends UpdateState {}

class UpdateError extends UpdateState {
  UpdateError({required this.update});

  final AvailableUpdate update;

  @override
  List<Object?> get props => [update];
}
