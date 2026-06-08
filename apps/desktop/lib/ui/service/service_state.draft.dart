// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark, must_be_immutable

part of 'service_state.dart';

// **************************************************************************
// DraftGenerator
// **************************************************************************

class PendingMultipleAddressesDraft implements PendingMultipleAddresses {
  // Mutable fields
  bool starting;

  // Getters and setters for nested draftable fields

  PendingMultipleAddressesDraft({required this.starting});

  PendingMultipleAddresses save() =>
      PendingMultipleAddresses(starting: starting);

  @override
  List<Object?> get props => save().props;
  @override
  bool? get stringify => save().stringify;
  @override
  int get hashCode => save().hashCode;

  @override
  String toString() => save().toString();
}

extension PendingMultipleAddressesDraftExtension on PendingMultipleAddresses {
  PendingMultipleAddressesDraft draft() =>
      PendingMultipleAddressesDraft(starting: this.starting);
  PendingMultipleAddresses produce(
    void Function(PendingMultipleAddressesDraft draft) producer,
  ) {
    final draft = this.draft();
    producer(draft);
    return draft.save();
  }
}

class StartupErrorDraft implements StartupError {
  // Mutable fields
  ServiceErrorCause cause;
  bool restartTriggered;

  // Getters and setters for nested draftable fields

  StartupErrorDraft({required this.cause, required this.restartTriggered});

  StartupError save() =>
      StartupError(cause: cause, restartTriggered: restartTriggered);

  @override
  List<Object?> get props => save().props;
  @override
  bool? get stringify => save().stringify;
  @override
  int get hashCode => save().hashCode;

  @override
  String toString() => save().toString();
}

extension StartupErrorDraftExtension on StartupError {
  StartupErrorDraft draft() => StartupErrorDraft(
    cause: this.cause,
    restartTriggered: this.restartTriggered,
  );
  StartupError produce(void Function(StartupErrorDraft draft) producer) {
    final draft = this.draft();
    producer(draft);
    return draft.save();
  }
}
