import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../../data/models.dart';
import '../../../i18n/strings.g.dart';
import '../game_cubit.dart';

class const LobbyRolePreferencesCard({
  super.key,
  required final bool loading,
  required final LobbyRoleSelection preferences,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.navy.withValues(alpha: 0.025),
        border: .all(color: colors.navy.withValues(alpha: 0.12)),
        borderRadius: .circular(16),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            t.lobbyRolePreferences.title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.navy.withValues(alpha: 0.72),
              fontWeight: .w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          _RolePreferenceRow(
            label: t.lobbyRolePreferences.primaryLabel,
            role: preferences.first,
            onTap: loading
                ? null
                : () => LobbyRolePreferenceModal.show(
                    context,
                    preferences: preferences,
                    primary: true,
                  ),
          ),
          const Divider(height: 1),
          _RolePreferenceRow(
            label: t.lobbyRolePreferences.secondaryLabel,
            role: preferences.second,
            onTap: loading
                ? null
                : () => LobbyRolePreferenceModal.show(
                    context,
                    preferences: preferences,
                    primary: false,
                  ),
          ),
        ],
      ),
    );
  }
}

class const _RolePreferenceRow({
  required final String label,
  required final LobbyRole role,
  required final VoidCallback? onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const .symmetric(horizontal: 2),
      onTap: onTap,
      title: Text(label),
      trailing: Row(
        mainAxisSize: .min,
        children: [
          Text(role.displayName),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class const LobbyRolePreferenceModal({
  super.key,
  required final LobbyRoleSelection preferences,
  required final bool primary,
}) extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required LobbyRoleSelection preferences,
    required bool primary,
  }) async {
    final cubit = context.read<GameCubit>();
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      constraints: const BoxConstraints(minWidth: .infinity),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: LobbyRolePreferenceModal(preferences: preferences, primary: primary),
      ),
    );
  }

  void _selectAndPop(BuildContext context, LobbyRole role) {
    final cubit = context.read<GameCubit>();
    cubit.updateLobbyRolePreferences(
      first: primary ? role : preferences.first,
      second: primary ? preferences.second : role,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final current = primary ? preferences.first : preferences.second;
    final unavailable = primary ? preferences.second : preferences.first;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: ListView(
        shrinkWrap: true,
        padding: const .fromLTRB(20, 4, 20, 0),
        children: [
          Text(
            primary
                ? t.lobbyRolePreferences.primarySelectionTitle
                : t.lobbyRolePreferences.secondarySelectionTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 5),
          Text(t.lobbyRolePreferences.selectionDescription),
          const SizedBox(height: 12),
          for (final role in LobbyRole.values.where((role) => role != unavailable))
            ListTile(
              contentPadding: const .symmetric(horizontal: 14),
              onTap: () => _selectAndPop(context, role),
              title: Text(role.displayName),
              trailing: role == current ? const Icon(Icons.check) : null,
            ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
