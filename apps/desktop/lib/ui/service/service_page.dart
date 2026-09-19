import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../app_manager.dart';
import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../widgets/app_shell.dart';
import '../widgets/layout.dart';
import 'service_cubit.dart';
import 'service_state.dart';

class const ServicePage({
  super.key,
  required final WidgetBuilder startedBuilder,
}) extends StatelessWidget {
  static Widget builder({required WidgetBuilder startedBuilder}) {
    return BlocProvider(
      create: Dependencies.serviceCubit,
      child: ServicePage(startedBuilder: startedBuilder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ServiceCubit>();
    final colorScheme = context.remoteRiftTheme.colorScheme;

    return Lifecycle(
      onInit: () {
        cubit.initialize();
        appManager.addExitListener(cubit.dispose);
      },
      onDispose: () {
        appManager.removeExitListener(cubit.dispose);
        cubit.dispose();
      },
      child: switch (cubit.state) {
        Started() => startedBuilder(context),
        _ => AppShell(
          body: switch (cubit.state) {
            Initial() || Started() => SizedBox.shrink(),

            Starting() => AppStatusLayout(
              eyebrow: t.service.statusEyebrow,
              title: t.service.startingTitle,
              description: t.service.startingDescription,
              icon: AppStatusIcon(
                data: Icons.power_outlined,
                color: colorScheme.neutral,
              ),
              tone: .active,
              loading: true,
            ),

            StartupError(:var cause, :var restartTriggered) => AppStatusLayout(
              eyebrow: t.service.statusEyebrow,
              title: t.service.errorTitle,
              description: cause.description,
              icon: .error(colorScheme),
              tone: .error,
              loading: restartTriggered,
              action: AppStatusAction(
                label: t.service.errorRetry,
                onPressed: cubit.restart,
              ),
            ),
          },
        ),
      },
    );
  }
}
