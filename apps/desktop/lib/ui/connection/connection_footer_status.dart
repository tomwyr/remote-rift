import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import '../widgets/app_tooltip.dart';
import 'connection_cubit.dart';
import 'connection_state.dart';

class const ConnectionFooterStatus() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ConnectionCubit>().state;
    final colors = context.remoteRiftTheme.colorScheme;
    final status = switch (state) {
      Initial() => null,
      Connecting() => (
        color: colors.gold,
        message: t.connection.connectingStatus,
        icon: Icons.wifi_tethering_rounded,
      ),
      Connected() => (
        color: colors.ready,
        message: t.connection.connectedStatus,
        icon: Icons.wifi_rounded,
      ),
      ConnectedWithError() || ConnectionError() => (
        color: colors.error,
        message: t.connection.unavailableStatus,
        icon: Icons.wifi_off_rounded,
      ),
    };

    if (status == null) {
      return const SizedBox.shrink();
    }

    return AppTooltip(
      message: status.message,
      child: Icon(status.icon, size: 16, color: status.color),
    );
  }
}
