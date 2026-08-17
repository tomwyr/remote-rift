import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import 'update_cubit.dart';
import 'update_page.dart';
import 'update_state.dart';

class const UpdateButton({super.key}) extends StatelessWidget {
  static Widget builder() {
    return BlocProvider(
      create: Dependencies.updateCubit,
      child: UpdateButton(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateCubit>();
    final state = context.watch<UpdateCubit>().state;

    return Lifecycle(
      onInit: cubit.initialize,
      child: switch (state) {
        Initial() || UpToDate() => SizedBox.shrink(),
        UpdateAvailable() || UpdateInProgress() || UpdateError() => IconButton(
          onPressed: () => UpdatePage.show(context),
          tooltip: t.update.installTooltip,
          icon: Icon(
            Icons.system_update_alt,
            color: context.remoteRiftTheme.colorScheme.navy,
          ),
        ),
      },
    );
  }
}
