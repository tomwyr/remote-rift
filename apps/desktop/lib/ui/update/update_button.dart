import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import 'update_cubit.dart';
import 'update_page.dart';
import 'update_state.dart';

class const UpdateButton({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<UpdateCubit>().state;

    return switch (state) {
      Initial() || UpToDate() || UpdateCheckFailed() => SizedBox.shrink(),
      UpdateAvailable() || UpdateInProgress() || UpdateError() => IconButton(
        onPressed: () => UpdatePage.show(context),
        tooltip: t.update.installTooltip,
        icon: Icon(
          Icons.system_update_alt,
          color: context.remoteRiftTheme.colorScheme.navy,
        ),
      ),
    };
  }
}
