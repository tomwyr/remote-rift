import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../app_manager.dart';
import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
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
      child: Scaffold(
        body: Padding(
          padding: .symmetric(horizontal: 24, vertical: 12),
          child: switch (cubit.state) {
            Initial() => SizedBox.shrink(),

            Starting() => BasicLayout(
              title: t.service.startingTitle,
              description: t.service.startingDescription,
              icon: .new(
                data: Icons.power_outlined,
                color: colorScheme.neutral,
              ),
              loading: true,
            ),

            StartupError(:var cause, :var restartTriggered) => BasicLayout(
              title: t.service.errorTitle,
              description: cause.description,
              icon: .error(colorScheme),
              loading: restartTriggered,
              action: .new(
                label: t.service.errorRetry,
                onPressed: cubit.restart,
              ),
            ),

            PendingMultipleAddresses(:var starting) => BasicLayout(
              title: t.service.pendingMultipleAddressesTitle,
              description: t.service.pendingMultipleAddressesDescription,
              icon: .warning(colorScheme),
              action: .new(
                label: t.service.pendingMultipleAddressesContinue,
                onPressed: cubit.completeStartup,
              ),
              loading: starting,
            ),

            Started() => startedBuilder(context),
          },
        ),
      ),
    );
  }
}
