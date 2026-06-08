import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import '../widgets/layout.dart';
import 'update_cubit.dart';
import 'update_state.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

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
      child: Scaffold(
        body: Padding(
          padding: .symmetric(horizontal: 24, vertical: 12),
          child: switch (state) {
            Initial() || UpToDate() => const SizedBox.shrink(),

            UpdateAvailable() => BasicLayout(
              title: t.update.availableTitle,
              description: t.update.availableDescription,
              icon: .update(colorScheme),
              action: .new(
                label: t.update.availableConfirmLabel,
                onPressed: cubit.installUpdate,
              ),
              secondaryAction: .new(
                label: t.update.availableCancelLabel,
                onPressed: Navigator.of(context).pop,
              ),
            ),

            UpdateInProgress() => BasicLayout(
              title: t.update.inProgressTitle,
              description: t.update.inProgressDescription,
              icon: .update(colorScheme),
              loading: true,
            ),

            UpdateError() => BasicLayout(
              title: t.update.errorTitle,
              description: t.update.errorDescription,
              icon: .error(colorScheme),
              action: .new(
                label: t.update.errorRetryLabel,
                onPressed: cubit.installUpdate,
              ),
              secondaryAction: .new(
                label: t.update.availableCancelLabel,
                onPressed: Navigator.of(context).pop,
              ),
            ),
          },
        ),
      ),
    );
  }
}
