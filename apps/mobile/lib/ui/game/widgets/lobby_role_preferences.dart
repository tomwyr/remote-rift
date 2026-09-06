import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../../data/models.dart';
import '../../../i18n/strings.g.dart';
import '../../widgets/layout.dart';
import '../game_cubit.dart';

class const LobbyRolePreferencesCard({
  super.key,
  required final bool loading,
  required final LobbyRolePreferences preferences,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return AppCard(
      child: Material(
        color: Colors.transparent,
        borderRadius: .circular(16),
        clipBehavior: .antiAlias,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const .fromLTRB(16, 16, 16, 8),
              child: Text(
                t.lobbyRolePreferences.title.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.navy.withValues(alpha: 0.72),
                  fontWeight: .w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            switch (preferences) {
              LobbyRoleSelection preferences => _SelectedRolePreferences(
                loading: loading,
                preferences: preferences,
              ),
              UnselectedLobbyRolePreferences() ||
              FillLobbyRolePreferences() => _UnselectedRolePreferences(
                enabled: !loading,
              ),
            },
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class const _UnselectedRolePreferences({required final bool enabled}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const .symmetric(horizontal: 16),
      enabled: enabled,
      onTap: enabled ? () => LobbyRolePreferenceModal.selectInitial(context) : null,
      title: Text(t.lobbyRolePreferences.selectRolesLabel),
      subtitle: Text(t.lobbyRolePreferences.selectionDescription),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class const _SelectedRolePreferences({
  required final bool loading,
  required final LobbyRoleSelection preferences,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RolePreferenceRow(
          label: t.lobbyRolePreferences.primaryLabel,
          role: preferences.first,
          onTap: loading
              ? null
              : () => LobbyRolePreferenceModal.selectAndUpdate(
                  context,
                  current: preferences.first,
                  slot: .primary,
                ),
        ),
        const AppListDivider(),
        _RolePreferenceRow(
          label: t.lobbyRolePreferences.secondaryLabel,
          role: preferences.second,
          onTap: loading
              ? null
              : () => LobbyRolePreferenceModal.selectAndUpdate(
                  context,
                  current: preferences.second,
                  slot: .secondary,
                ),
        ),
      ],
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
      contentPadding: const .symmetric(horizontal: 16),
      onTap: onTap,
      title: Text(role.displayName),
      trailing: Row(
        mainAxisSize: .min,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class const LobbyRolePreferenceModal({
  super.key,
  required final String title,
  required final LobbyRole? current,
  required final LobbyRole? unavailable,
}) extends StatelessWidget {
  static Future<void> selectInitial(BuildContext context) async {
    final cubit = context.read<GameCubit>();
    final first = await select(
      context,
      title: t.lobbyRolePreferences.primarySelectionTitle,
    );
    if (first == null || !context.mounted) {
      return;
    }

    final second = await select(
      context,
      title: t.lobbyRolePreferences.secondarySelectionTitle,
      unavailable: first,
    );
    if (second == null || !context.mounted) {
      return;
    }

    cubit.updateLobbyRolePreferences(first: first, second: second);
  }

  static Future<void> selectAndUpdate(
    BuildContext context, {
    required LobbyRole current,
    required LobbyRolePreferenceSlot slot,
  }) async {
    final cubit = context.read<GameCubit>();
    final role = await select(
      context,
      title: switch (slot) {
        .primary => t.lobbyRolePreferences.primarySelectionTitle,
        .secondary => t.lobbyRolePreferences.secondarySelectionTitle,
      },
      current: current,
    );
    if (role == null || !context.mounted) {
      return;
    }

    cubit.updateLobbyRolePreference(role: role, slot: slot);
  }

  static Future<LobbyRole?> select(
    BuildContext context, {
    required String title,
    LobbyRole? current,
    LobbyRole? unavailable,
  }) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      constraints: const BoxConstraints(minWidth: .infinity),
      builder: (_) => LobbyRolePreferenceModal(
        title: title,
        current: current,
        unavailable: unavailable,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: ListView(
        shrinkWrap: true,
        padding: const .fromLTRB(20, 4, 20, 0),
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 5),
          Text(t.lobbyRolePreferences.selectionDescription),
          const SizedBox(height: 12),
          for (final role in LobbyRole.values.where((role) => role != unavailable))
            ListTile(
              contentPadding: const .symmetric(horizontal: 14),
              onTap: () => Navigator.of(context).pop(role),
              title: Text(role.displayName),
              trailing: role == current ? const Icon(Icons.check) : null,
            ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
