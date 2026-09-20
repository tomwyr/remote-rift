import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../widgets/app_shell.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/app_value_box.dart';
import '../widgets/layout.dart';
import '../mcp/mcp_settings_card.dart';
import 'settings_cubit.dart';
import 'settings_state.dart';

class const SettingsPage({super.key}) extends StatelessWidget {
  static void show(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: Dependencies.settingsCubit,
          child: SettingsPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();

    return Lifecycle(
      onInit: cubit.initialize,
      child: AppShell(
        title: t.settings.title,
        showUpdateAction: false,
        trailing: AppIconButton(
          tooltip: t.settings.close,
          icon: Icons.close,
          onPressed: Navigator.of(context).pop,
        ),
        body: switch (cubit.state) {
          Initial() => const SizedBox.shrink(),
          Loaded state => _SettingsCards(state: state),
        },
      ),
    );
  }
}

class const _SettingsCards({required final Loaded state}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _LockfileLocationCard(state: state),
        const SizedBox(height: 12),
        const McpSettingsCard(),
      ],
    );
  }
}

class const _LockfileLocationCard({required final Loaded state}) extends StatelessWidget {
  Future<void> _chooseCustomPath(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();
    final selection = await openFile();
    if (selection case final selection?) {
      cubit.selectCustomPath(selection.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final colors = context.remoteRiftTheme.colorScheme;
    final failure = switch (state.failure) {
      .invalidLockfile => t.settings.lockfile.invalid,
      .pathPersistence => t.settings.lockfile.persistenceFailed,
      null => null,
    };
    final mode = state.usesCustomPath
        ? t.settings.lockfile.customLocation
        : t.settings.lockfile.defaultLocation;
    final description = state.usesCustomPath
        ? t.settings.lockfile.customPath
        : t.settings.lockfile.defaultPath;

    return AppCard(
      padding: .all(20),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          AppEyebrow(label: t.settings.lockfile.title, accent: colors.gold),
          const SizedBox(height: 16),
          Text(
            mode,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: .w400),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style:
                Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(
                  color: colors.navy.withValues(alpha: .72),
                  fontWeight: .w400,
                  height: 1.42,
                ),
          ),
          if (state.customPath case var path?) ...[
            const SizedBox(height: 12),
            AppValueBox(child: Text(path)),
          ],
          if (failure case var failure?) ...[
            const SizedBox(height: 12),
            Container(
              padding: .all(12),
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.08),
                borderRadius: .circular(12),
              ),
              child: Text(failure, style: TextStyle(color: colors.error)),
            ),
          ],
          SizedBox(height: failure == null ? 20 : 16),
          ElevatedButton(
            onPressed: state.saving ? null : () => _chooseCustomPath(context),
            child: Text(
              state.usesCustomPath ? t.settings.lockfile.change : t.settings.lockfile.choose,
            ),
          ),
          if (state.usesCustomPath) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: state.saving ? null : cubit.reset,
              child: Text(t.settings.lockfile.reset),
            ),
          ],
        ],
      ),
    );
  }
}
