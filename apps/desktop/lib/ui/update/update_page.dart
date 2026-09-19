import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import '../widgets/app_shell.dart';
import '../widgets/layout.dart';
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
    final canRetry = state.canRetry;

    return Lifecycle(
      onDispose: cubit.recoverOnDismiss,
      child: AppShell(
        showUpdateAction: false,
        trailing: IconButton(
          onPressed: Navigator.of(context).pop,
          tooltip: t.update.availableCancelLabel,
          icon: const Icon(Icons.close),
        ),
        body: switch (state) {
          Initial() || UpToDate() || UpdateCheckFailed() => const SizedBox.shrink(),

          UpdateAvailable() => AppStatusLayout(
            eyebrow: t.update.statusEyebrow,
            title: t.update.availableTitle,
            description: t.update.availableDescription,
            icon: .update(colorScheme),
            tone: .ready,
            action: AppStatusAction(
              label: t.update.availableConfirmLabel,
              onPressed: cubit.installUpdate,
            ),
            secondaryAction: AppStatusAction(
              label: t.update.availableCancelLabel,
              onPressed: Navigator.of(context).pop,
            ),
          ),

          UpdateInProgress() => AppStatusLayout(
            eyebrow: t.update.statusEyebrow,
            title: t.update.inProgressTitle,
            description: t.update.inProgressDescription,
            icon: .update(colorScheme),
            tone: .active,
            loading: true,
          ),

          UpdateError() => AppStatusLayout(
            eyebrow: t.update.statusEyebrow,
            title: t.update.errorTitle,
            description: t.update.errorDescription,
            icon: .error(colorScheme),
            tone: .error,
            action: AppStatusAction(
              label: t.update.errorRetryLabel,
              onPressed: canRetry ? cubit.installUpdate : null,
            ),
            secondaryAction: AppStatusAction(
              label: t.update.availableCancelLabel,
              onPressed: Navigator.of(context).pop,
            ),
          ),
        },
      ),
    );
  }
}
