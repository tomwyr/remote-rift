import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import '../app/app_notifications.dart';
import '../widgets/layout.dart';
import 'mcp_integration_cubit.dart';
import 'mcp_integration_state.dart';

class const McpIntegrationPanel() extends StatelessWidget {
  static void show(BuildContext context) {
    final cubit = context.read<McpIntegrationCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(value: cubit, child: McpIntegrationPanel()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<McpIntegrationCubit>().state;

    return SafeArea(
      child: Padding(
        padding: const .fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            Text(t.mcp.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(t.mcp.localOnly),
            const SizedBox(height: 16),
            switch (state) {
              Idle() => Text(t.mcp.capabilities),
              Starting() => const _McpLoadingState(),
              Running(:final hostConfiguration) => _McpStatus(configuration: hostConfiguration),
              Failed() => const _McpFailedState(),
            },
            const SizedBox(height: 16),
            _McpActions(state: state),
          ],
        ),
      ),
    );
  }
}

class const _McpStatus({required final String configuration}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(t.mcp.running, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(t.mcp.configuration, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        SelectableText(configuration, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _copyConfiguration(context),
          icon: const Icon(Icons.copy_outlined),
          label: Text(t.mcp.copy),
        ),
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
    return const Center(
      child: Padding(padding: .all(20), child: CircularProgressIndicator()),
    );
  }
}

class const _McpFailedState() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppStatusLayout(
      eyebrow: t.mcp.title,
      description: t.mcp.error,
      icon: .error(context.remoteRiftTheme.colorScheme),
      tone: .error,
    );
  }
}

class const _McpActions({required final McpIntegrationState state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<McpIntegrationCubit>();

    return switch (state) {
      Running() => Column(
        crossAxisAlignment: .stretch,
        children: [
          OutlinedButton(onPressed: cubit.reset, child: Text(t.mcp.reset)),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: cubit.disable, child: Text(t.mcp.disable)),
        ],
      ),
      Starting() => const SizedBox.shrink(),
      Idle() || Failed() => ElevatedButton(onPressed: cubit.enable, child: Text(t.mcp.enable)),
    };
  }
}
