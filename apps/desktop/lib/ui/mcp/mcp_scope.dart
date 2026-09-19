import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../app_manager.dart';
import '../../dependencies.dart';
import 'mcp_integration_cubit.dart';

class McpScope({
  super.key,
  required final Widget child,
}) extends StatelessWidget {
  static Widget builder({required Widget child}) {
    return BlocProvider(
      create: Dependencies.mcpIntegrationCubit,
      child: McpScope(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<McpIntegrationCubit>();

    return Lifecycle(
      onInit: () => appManager.addExitListener(cubit.close),
      onDispose: () => appManager.removeExitListener(cubit.close),
      child: child,
    );
  }
}
