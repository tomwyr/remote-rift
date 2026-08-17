import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import '../widgets/layout.dart';
import '../widgets/app_shell.dart';
import 'update_cubit.dart';
import 'update_state.dart';

class const UpdatePage({super.key}) extends StatelessWidget {
  static void show(BuildContext context) {
    final cubit = context.read<UpdateCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(value: cubit, child: UpdatePage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateCubit>();
    final state = context.watch<UpdateCubit>().state;

    final colorScheme = context.remoteRiftTheme.colorScheme;

    return Lifecycle(
      onDispose: cubit.recoverOnDismiss,
      child: DesktopAppShell(
        showUpdateAction: false,
        trailing: IconButton(
          onPressed: Navigator.of(context).pop,
          tooltip: t.update.availableCancelLabel,
          icon: const Icon(Icons.close),
        ),
        body: switch (state) {
          Initial() || UpToDate() => const SizedBox.shrink(),

          UpdateAvailable() => BasicLayout(
            eyebrow: t.update.statusEyebrow,
            title: t.update.availableTitle,
            description: t.update.availableDescription,
            icon: .update(colorScheme),
            tone: .ready,
            action: BasicLayoutAction(
              label: t.update.availableConfirmLabel,
              onPressed: cubit.installUpdate,
            ),
            secondaryAction: BasicLayoutAction(
              label: t.update.availableCancelLabel,
              onPressed: Navigator.of(context).pop,
            ),
          ),

          UpdateInProgress() => BasicLayout(
            eyebrow: t.update.statusEyebrow,
            title: t.update.inProgressTitle,
            description: t.update.inProgressDescription,
            icon: .update(colorScheme),
            tone: .active,
            loading: true,
          ),

          UpdateError() => BasicLayout(
            eyebrow: t.update.statusEyebrow,
            title: t.update.errorTitle,
            description: t.update.errorDescription,
            icon: .error(colorScheme),
            tone: .error,
            action: BasicLayoutAction(
              label: t.update.errorRetryLabel,
              onPressed: cubit.installUpdate,
            ),
            secondaryAction: BasicLayoutAction(
              label: t.update.availableCancelLabel,
              onPressed: Navigator.of(context).pop,
            ),
          ),
        },
      ),
    );
  }
}
