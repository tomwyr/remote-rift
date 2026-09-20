import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import '../widgets/app_tooltip.dart';
import 'mcp_integration_cubit.dart';
import 'mcp_integration_state.dart';

class const McpFooterStatus() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<McpIntegrationCubit>().state;
    final colors = context.remoteRiftTheme.colorScheme;
    final status = switch (state) {
      Running() => (color: colors.ready, message: t.mcp.running),
      Starting() => (color: colors.gold, message: t.mcp.starting),
      Resetting() => (color: colors.gold, message: t.mcp.resetting),
      Idle() || Stopped() || Failed() => null,
    };

    if (status == null) {
      return const SizedBox.shrink();
    }

    return AppTooltip(
      message: status.message,
      child: Icon(Icons.smart_toy_outlined, size: 16, color: status.color),
    );
  }
}
