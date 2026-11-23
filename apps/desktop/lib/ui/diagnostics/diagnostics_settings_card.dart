import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../app/app_notifications.dart';
import '../widgets/app_switch.dart';
import '../widgets/app_value_box.dart';
import '../widgets/layout.dart';
import 'diagnostics_cubit.dart';
import 'diagnostics_state.dart';

class const DiagnosticsSettingsCard({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: Dependencies.diagnosticsCubit,
      child: const _DiagnosticsSettings(),
    );
  }
}

class const _DiagnosticsSettings() extends StatelessWidget {
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
        child: loaded
            ? AppCard(
                padding: .all(20),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .stretch,
                  children: [
                    AppEyebrow(label: t.diagnostics.title, accent: colors.gold),
                    const SizedBox(height: 16),
                    const _LoggingPreference(),
                    const SizedBox(height: 20),
                    const _LogStorageSettings(),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void _onEvent(BuildContext context, DiagnosticsEvent event) {
    final notifications = AppNotifications.of(context);

    switch (event) {
      case LogExportPrepared(:var filename):
        _chooseExportDestination(context, filename);

      case LogsCleared():
        notifications.show(
          type: .success,
          title: t.diagnostics.title,
          description: t.diagnostics.cleared,
        );

      case LogsExported():
        notifications.show(
          type: .success,
          title: t.diagnostics.title,
          description: t.diagnostics.exported,
        );

      case NoLogsToExport():
        notifications.show(
          type: .info,
          title: t.diagnostics.title,
          description: t.diagnostics.exportEmpty,
        );

      case LogExportCancelled():
        notifications.show(
          type: .info,
          title: t.diagnostics.title,
          description: t.diagnostics.exportCancelled,
        );
    }
  }

  Future<void> _chooseExportDestination(BuildContext context, String suggestedName) async {
    final cubit = context.read<DiagnosticsCubit>();
    try {
      final selection = await getSaveLocation(suggestedName: suggestedName);
      final destination = switch (selection) {
        FileSaveLocation(:var path) => ExportPath(path),
        null => ExportCancelled(),
      };
      cubit.completeExport(destination);
    } catch (_) {
      cubit.completeExport(ExportDestinationFailed());
    }
  }
}

class const _LoggingPreference() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DiagnosticsCubit>();
    final state = cubit.state;
    if (state is! Loaded) return const SizedBox.shrink();

    final colors = context.remoteRiftTheme.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final preferenceError = switch (state.actions) {
      DiagnosticsActions(savePreference: .failed) => t.diagnostics.settingFailed,
      DiagnosticsActions(loadPreference: .failed) => t.diagnostics.settingUnavailable,
      _ => null,
    };

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(t.diagnostics.logging, style: textTheme.titleMedium)),
            AppSwitch(
              value: state.captureEnabled,
              onChanged: state.canChangeCapture ? cubit.updateCapture : null,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          t.diagnostics.privacy,
          style: textTheme.bodyMedium?.copyWith(color: colors.navy.withValues(alpha: .72)),
        ),
        if (preferenceError case var error?) ...[
          const SizedBox(height: 12),
          Text(error, style: TextStyle(color: colors.error)),
        ],
      ],
    );
  }
}

class const _LogStorageSettings() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DiagnosticsCubit>();
    final state = cubit.state;
    if (state is! Loaded) return const SizedBox.shrink();

    final errorStyle = TextStyle(color: context.remoteRiftTheme.colorScheme.error);
    final clearFailed = state.actions.clearLogs == .failed;
    final exportError = switch (state.actions.exportLogs) {
      .preparationFailed => t.diagnostics.exportPreparationFailed,
      .saveFailed => t.diagnostics.exportSaveFailed,
      .idle || .pending => null,
    };

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (state.storageStatus == .unavailable) ...[
          AppValueBox(child: Text(t.diagnostics.storageUnavailable, style: errorStyle)),
          const SizedBox(height: 20),
        ],
        ElevatedButton(
          onPressed: state.canExport ? cubit.exportLogs : null,
          child: Text(state.canExport ? t.diagnostics.export : t.diagnostics.exporting),
        ),
        if (exportError case var message?) ...[
          const SizedBox(height: 8),
          Text(message, style: errorStyle),
        ],
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: state.canClear ? cubit.clearLogs : null,
          child: Text(state.canClear ? t.diagnostics.clear : t.diagnostics.clearing),
        ),
        if (clearFailed) ...[
          const SizedBox(height: 8),
          Text(t.diagnostics.clearFailed, style: errorStyle),
        ],
      ],
    );
  }
}
