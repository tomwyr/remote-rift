import 'package:equatable/equatable.dart';

sealed class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends SettingsState;

class Loaded({
  required final String? customPath,
  final SettingsFailure? failure,
  final bool saving = false,
}) extends SettingsState {
  bool get usesCustomPath => customPath != null;

  @override
  List<Object?> get props => [customPath, failure, saving];
}

enum SettingsFailure { invalidLockfile, pathPersistence }
