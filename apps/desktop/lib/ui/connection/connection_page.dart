import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../widgets/app_shell.dart';
import '../widgets/layout.dart';
import 'connection_cubit.dart';
import 'connection_state.dart';

class const ConnectionPage({super.key}) extends StatelessWidget {
  static Widget builder() {
    return BlocProvider(
      create: Dependencies.connectionCubit,
      child: ConnectionPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ConnectionCubit>();
    final colorScheme = context.remoteRiftTheme.colorScheme;

    return Lifecycle(
      onInit: cubit.initialize,
      child: DesktopAppShell(
        trailing: Row(
          mainAxisSize: .min,
          children: [ConnectionStatusIcon(state: cubit.state)],
        ),
        body: switch (cubit.state) {
          Initial() => SizedBox.shrink(),

          Connecting() => BasicLayout(
            eyebrow: t.connection.statusEyebrow,
            title: t.connection.connectingTitle,
            description: t.connection.connectingDescription,
            icon: BasicLayoutIcon(
              data: Icons.wifi_tethering_rounded,
              color: colorScheme.neutral,
            ),
            tone: .active,
            loading: true,
          ),

          ConnectionError(:var reconnectTriggered) => BasicLayout(
            eyebrow: t.connection.statusEyebrow,
            title: t.connection.errorTitle,
            description: t.connection.errorDescription,
            icon: .error(colorScheme),
            tone: .error,
            loading: reconnectTriggered,
            action: BasicLayoutAction(
              label: t.connection.errorRetry,
              onPressed: cubit.reconnect,
            ),
          ),

          ConnectedWithError(:var cause) => BasicLayout(
            eyebrow: t.connection.statusEyebrow,
            title: cause.title,
            description: cause.description,
            icon: .warning(colorScheme),
            tone: .warning,
          ),

          Connected() => BasicLayout(
            eyebrow: t.connection.statusEyebrow,
            title: t.connection.connectedTitle,
            description: t.connection.connectedDescription,
            icon: BasicLayoutIcon(
              data: Icons.check_rounded,
              color: colorScheme.success,
            ),
            tone: .ready,
          ),
        },
      ),
    );
  }
}

class const ConnectionStatusIcon({
  super.key,
  required final ConnectionState state,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;
    final isConnected = state is Connected;
    return Padding(
      padding: const .symmetric(horizontal: 6),
      child: Icon(
        isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
        color: isConnected ? colors.ready : colors.gold,
        size: 20,
      ),
    );
  }
}

extension on RemoteRiftError {
  String get title => switch (this) {
    .unableToConnect => t.gameError.unableToConnectTitle,
    .unknown => t.gameError.unknownTitle,
  };

  String get description => switch (this) {
    .unableToConnect => t.gameError.unableToConnectDescription,
    .unknown => t.gameError.unknownDescription,
  };
}
