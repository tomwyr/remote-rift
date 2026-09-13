import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../app/app_notifications.dart';
import 'update_cubit.dart';
import 'update_state.dart';

class const UpdateComponent({
  super.key,
  required final Widget child,
}) extends StatelessWidget {
  static Widget builder({required Widget child}) {
    return BlocProvider(
      create: Dependencies.updateCubit,
      child: UpdateComponent(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateCubit>();
    return EventsListener(
      events: cubit.events,
      onEvent: _onEvent,
      child: Lifecycle(onInit: cubit.initialize, child: child),
    );
  }

  void _onEvent(BuildContext context, UpdateEvent event) {
    final notifications = AppNotifications.of(context);

    switch (event) {
      case .installed:
        notifications.show(
          type: .success,
          title: t.update.installedTitle,
          description: t.update.installedDescription,
        );
      case .installationFailed:
        notifications.show(
          type: .error,
          title: t.update.installationFailedTitle,
          description: t.update.installationFailedDescription,
        );
    }
  }
}
