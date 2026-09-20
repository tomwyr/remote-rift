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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: Dependencies.mcpIntegrationCubit,
      child: Builder(
        builder: (context) {
          final cubit = context.read<McpIntegrationCubit>();

          return Lifecycle(
            onInit: () {
              appManager.addExitListener(cubit.close);
              cubit.initialize();
            },
            onDispose: () => appManager.removeExitListener(cubit.close),
            child: child,
          );
        },
      ),
    );
  }
}
