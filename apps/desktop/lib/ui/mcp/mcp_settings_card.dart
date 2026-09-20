import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import '../app/app_notifications.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/app_switch.dart';
import '../widgets/app_value_box.dart';
import '../widgets/layout.dart';
import 'mcp_integration_cubit.dart';
import 'mcp_integration_state.dart';

class const McpSettingsCard() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<McpIntegrationCubit>().state;
    final status = state.status;
    final colors = context.remoteRiftTheme.colorScheme;

    return AppCard(
      padding: .all(20),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          AppEyebrow(label: t.mcp.title, accent: colors.gold),
          const SizedBox(height: 16),
          Text(t.mcp.connectTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(t.mcp.description),
          const SizedBox(height: 12),
          const _McpLocalInfo(),
          if (status case Starting() || Resetting() || Running() || Failed())
            const SizedBox(height: 16),
          switch (status) {
            Idle() || Stopped() => const SizedBox.shrink(),
            Starting() => const _McpLoadingState(),
            Resetting() || Running() => const _McpActiveSummary(),
            Failed(:var action) => _McpFailedState(action: action),
          },
          if (status case Running() || Resetting()) ...[
            const _McpSettingDivider(),
            const _McpStartOnLaunchSetting(),
          ],
          if (status case Idle() || Stopped() || Failed()) ...[
            const SizedBox(height: 16),
            _McpActions(status: status),
          ],
        ],
      ),
    );
  }
}

class const _McpLocalInfo() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return Align(
      alignment: .centerLeft,
      child: Container(
        padding: .symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colors.navy.withValues(alpha: .04),
          border: .all(color: colors.navy.withValues(alpha: .12)),
          borderRadius: .circular(8),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(Icons.computer_outlined, size: 16, color: colors.navy),
            const SizedBox(width: 6),
            Text(t.mcp.localOnly, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class const _McpSettingDivider() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return Divider(
      color: colors.navy.withValues(alpha: .12),
      height: 24,
    );
  }
}

class const _McpStartOnLaunchSetting() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<McpIntegrationCubit>();
    final startsOnLaunch = context.select(
      (McpIntegrationCubit cubit) => cubit.state.startsOnLaunch,
    );
    final colors = context.remoteRiftTheme.colorScheme;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(t.mcp.startOnLaunch, style: Theme.of(context).textTheme.titleSmall),
            ),
            const SizedBox(width: 12),
            AppSwitch(
              value: startsOnLaunch,
              onChanged: cubit.updateStartsOnLaunch,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          t.mcp.startOnLaunchDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.navy.withValues(alpha: .72),
          ),
        ),
      ],
    );
  }
}

class const _McpActiveSummary() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: colors.navy,
        alignment: .centerLeft,
        padding: .zero,
      ),
      onPressed: () => McpDetailsSheet.show(context),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Icon(Icons.check_circle_outline_rounded, size: 20, color: colors.ready),
          const SizedBox(width: 8),
          Expanded(child: Text(t.mcp.running, style: Theme.of(context).textTheme.titleMedium)),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class const McpDetailsSheet() extends StatelessWidget {
  static void show(BuildContext context) {
    final cubit = context.read<McpIntegrationCubit>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(value: cubit, child: McpDetailsSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<McpIntegrationCubit>().state;
    final status = state.status;
    final cubit = context.read<McpIntegrationCubit>();

    return EventsListener(
      events: cubit.events,
      onEvent: (context, event) {
        if (event case .stopped) {
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const .fromLTRB(20, 20, 20, 20),
          child: switch (status) {
            Running(:var hostConfiguration) ||
            Resetting(lastRunningState: Running(:var hostConfiguration)) ||
            Stopped(lastRunningState: Running(:var hostConfiguration)) => _McpDetails(
              configuration: hostConfiguration,
              status: status,
            ),
            Starting() => const _McpLoadingState(),
            Failed(:final action) => _McpFailedState(action: action),
            Idle() => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}

class const _McpDetails({
  required final String configuration,
  required final McpIntegrationStatus status,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(t.mcp.configuration, style: Theme.of(context).textTheme.titleLarge),
            ),
            AppIconButton(
              icon: Icons.close,
              onPressed: Navigator.of(context).pop,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          t.mcp.configurationDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.remoteRiftTheme.colorScheme.navy.withValues(alpha: .72),
            fontWeight: .w400,
            height: 1.42,
          ),
        ),
        const SizedBox(height: 12),
        AppValueBox(
          child: SelectableText(configuration, style: Theme.of(context).textTheme.bodySmall),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _copyConfiguration(context),
          icon: const Icon(Icons.copy_outlined),
          label: Text(t.mcp.copy),
        ),
        const SizedBox(height: 8),
        _McpActions(status: status),
      ],
    );
  }

  Future<void> _copyConfiguration(BuildContext context) async {
    final notifications = AppNotifications.of(context);

    await Clipboard.setData(ClipboardData(text: configuration));
    notifications.show(
      type: .success,
      title: t.mcp.configuration,
      description: t.mcp.copied,
    );
  }
}

class const _McpLoadingState() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(t.mcp.starting, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class const _McpFailedState({required final McpAction action}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;
    final error = switch (action) {
      .start => t.mcp.startError,
      .reset => t.mcp.resetError,
      .stop => t.mcp.stopError,
      .configuration => t.mcp.configurationError,
    };

    return Container(
      padding: .all(12),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: .08),
        borderRadius: .circular(12),
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Text(error, style: TextStyle(color: colors.error)),
        ],
      ),
    );
  }
}

class _McpActions({required final McpIntegrationStatus status}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<McpIntegrationCubit>();

    return switch (status) {
      Running() => Column(
        crossAxisAlignment: .stretch,
        children: [
          TextButton(onPressed: cubit.reset, child: Text(t.mcp.reset)),
          const SizedBox(height: 2),
          TextButton(onPressed: cubit.disable, child: Text(t.mcp.disable)),
        ],
      ),
      Resetting() => Column(
        crossAxisAlignment: .stretch,
        children: [
          TextButton.icon(
            onPressed: null,
            icon: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            label: Text(t.mcp.reset),
          ),
          const SizedBox(height: 2),
          TextButton(onPressed: null, child: Text(t.mcp.disable)),
        ],
      ),
      Starting() => const SizedBox.shrink(),
      Idle() || Stopped() || Failed() => ElevatedButton(
        onPressed: cubit.enable,
        child: Text(t.mcp.enable),
      ),
    };
  }
}
