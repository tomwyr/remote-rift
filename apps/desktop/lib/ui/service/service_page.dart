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

class ServicePage extends StatelessWidget {
  const ServicePage({super.key, required this.startedBuilder});

  final WidgetBuilder startedBuilder;

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
        _ => DesktopAppShell(
          body: switch (cubit.state) {
            Initial() || Started() => SizedBox.shrink(),

            Starting() => BasicLayout(
              eyebrow: t.service.statusEyebrow,
              title: t.service.startingTitle,
              description: t.service.startingDescription,
              icon: BasicLayoutIcon(
                data: Icons.power_outlined,
                color: colorScheme.neutral,
              ),
              tone: .active,
              loading: true,
            ),

            StartupError(:var cause, :var restartTriggered) => BasicLayout(
              eyebrow: t.service.statusEyebrow,
              title: t.service.errorTitle,
              description: cause.description,
              icon: .error(colorScheme),
              tone: .error,
              loading: restartTriggered,
              action: BasicLayoutAction(
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
