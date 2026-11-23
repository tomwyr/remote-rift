import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../app/app_notifications.dart';
import '../widgets/layout.dart';
import 'diagnostics_cubit.dart';
import 'diagnostics_state.dart';

class const DiagnosticsCard({super.key}) extends StatelessWidget {
  static Widget builder() {
    return BlocProvider(
      create: Dependencies.diagnosticsCubit,
      child: const DiagnosticsCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DiagnosticsCubit>();
    final loaded = context.select((DiagnosticsCubit cubit) => cubit.state is Loaded);
    final colors = context.remoteRiftTheme.colorScheme;

    return EventsListener(
      events: cubit.events,
      onEvent: _onEvent,
      child: Lifecycle(
        onInit: cubit.initialize,
        child: AppCard(
          padding: const .all(20),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              AppEyebrow(label: t.diagnostics.title, accent: colors.gold),
              if (loaded) ...[
                const _LoggingPreference(),
                const _LogActions(),
              ] else
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  void _onEvent(BuildContext context, DiagnosticsEvent event) {
    switch (event) {
      case LogSharePrepared(:var file):
        _openShareSheet(context, file);
      case LogsCleared():
        AppNotifications.show(context, t.diagnostics.cleared);
      case NoLogsToShare():
        AppNotifications.show(context, t.diagnostics.shareEmpty);
      case LogShareCancelled():
        AppNotifications.show(context, t.diagnostics.shareCancelled);
    }
  }

  Future<void> _openShareSheet(BuildContext context, File file) async {
    final cubit = context.read<DiagnosticsCubit>();

    try {
      final params = ShareParams(files: [XFile(file.path)]);
      final result = await SharePlus.instance.share(params);
      final LogShareResult shareResult = switch (result.status) {
        .dismissed => .cancelled,
        .success || .unavailable => .finished,
      };
      cubit.completeShare(shareResult, snapshot: file);
    } catch (_) {
      cubit.completeShare(.failed, snapshot: file);
    }
  }
}

class const _LoggingPreference() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DiagnosticsCubit>();
    final state = cubit.state;
    if (state is! Loaded) return const SizedBox.shrink();

    final strings = t.diagnostics;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final descriptionStyle = textTheme.bodyMedium?.copyWith(
      color: context.remoteRiftTheme.colorScheme.navy.withValues(alpha: 0.72),
    );
    final errorStyle = textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error);
    final preferenceError = switch (state.actions) {
      DiagnosticsActions(savePreference: .failed) => strings.settingFailed,
      DiagnosticsActions(loadPreference: .failed) => strings.settingUnavailable,
      _ => null,
    };

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 4,
                children: [
                  Text(strings.logging, style: textTheme.titleMedium),
                  Text(strings.privacy, style: descriptionStyle),
                ],
              ),
            ),
            Switch(
              value: state.captureEnabled,
              onChanged: state.canChangeCapture ? cubit.updateCapture : null,
            ),
          ],
        ),
        if (preferenceError case var error?) ...[
          const SizedBox(height: 8),
          Text(error, style: errorStyle),
        ],
      ],
    );
  }
}

class const _LogActions() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DiagnosticsCubit>();
    final state = cubit.state;
    if (state is! Loaded) return const SizedBox.shrink();

    final strings = t.diagnostics;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final errorStyle = textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error);
    final clearFailed = state.actions.clearLogs == .failed;
    final shareError = switch (state.actions.shareLogs) {
      .preparationFailed => strings.sharePreparationFailed,
      .shareFailed => strings.shareFailed,
      .idle || .pending => null,
    };

    return Column(
      crossAxisAlignment: .stretch,
      spacing: 8,
      children: [
        if (state.storageStatus == .unavailable)
          Text(strings.storageUnavailable, style: errorStyle),
        ElevatedButton(
          onPressed: state.canShare ? cubit.shareLogs : null,
          child: Text(state.canShare ? strings.share : strings.sharing),
        ),
        if (shareError case var message?) Text(message, style: errorStyle),
        OutlinedButton(
          onPressed: state.canClear ? cubit.clearLogs : null,
          child: Text(state.canClear ? strings.clear : strings.clearing),
        ),
        if (clearFailed) Text(strings.clearFailed, style: errorStyle),
      ],
    );
  }
}
