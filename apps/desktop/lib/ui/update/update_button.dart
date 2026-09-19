import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../i18n/strings.g.dart';
import '../widgets/app_icon_button.dart';
import 'update_cubit.dart';
import 'update_page.dart';
import 'update_state.dart';

class const UpdateButton({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<UpdateCubit>().state;

    return switch (state) {
      Initial() || UpToDate() || UpdateCheckFailed() => SizedBox.shrink(),
      UpdateAvailable() || UpdateInProgress() || UpdateError() => AppIconButton(
        onPressed: () => UpdatePage.show(context),
        tooltip: t.update.installTooltip,
        icon: Icons.system_update_alt,
      ),
    };
  }
}
