import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';
import 'package:time/time.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../champion_select/champion_select_component.dart';
import '../common/utils.dart';
import '../widgets/bloc_listener.dart';
import '../widgets/delayed_display.dart';
import '../widgets/layout.dart';
import 'game_cubit.dart';
import 'game_state.dart';
import 'widgets/game_data_body.dart';
import 'widgets/game_found_countdown.dart';
import 'widgets/game_queue_selection.dart';
import 'widgets/lobby_role_preferences.dart';

class const GameComponent({super.key}) extends StatelessWidget {
  static Widget builder() {
    return BlocProvider(create: Dependencies.gameCubit, child: GameComponent());
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GameCubit>();

    return BlocTransitionListener(
      bloc: cubit,
      listener: _vibrateOnStateChange,
      child: Lifecycle(
        onInit: cubit.initialize,
        onDispose: cubit.dispose,
        child: switch (cubit.state) {
          // Delay showing content to avoid flicker when loading appears for a single frame
          Loading() => DelayedDisplay(
            delay: 200.milliseconds,
            placeholder: BasicLayout(loading: true),
            child: BasicLayout(
              title: t.connection.loadingTitle,
              description: t.connection.loadingDescription,
              loading: true,
              tone: .active,
              icon: Icons.sync,
            ),
          ),

          Data(:var queueName, :var state, :var loading) => switch (state) {
            PreGame(:var availableQueues) => BasicLayout(
              body: GameDataBody(
                queueNamePlaceholder: GameQueueSelectionButton(
                  loading: loading,
                  availableQueues: availableQueues,
                ),
                title: t.gameState.preGameTitle,
                description: t.gameState.preGameDescription,
                tone: .neutral,
                icon: Icons.sports_esports_outlined,
              ),
              action: .new(
                label: t.home.createLobbyButton,
                onPressed: !loading
                    ? () => GameQueueSelectionModal.selectAndUpdateQueue(
                        context,
                        availableQueues: availableQueues,
                      )
                    : null,
              ),
            ),

            Lobby(state: .idle, :var rolePreferences) => BasicLayout(
              body: GameDataBody(
                queueName: queueName,
                title: t.gameState.lobbyIdleTitle,
                description: t.gameState.lobbyIdleDescription,
                tone: .neutral,
                icon: Icons.groups_outlined,
                child: switch (rolePreferences) {
                  LobbyRoleSelection preferences => LobbyRolePreferencesCard(
                    loading: loading,
                    preferences: preferences,
                  ),
                  _ => null,
                },
              ),
              action: .new(
                label: t.home.searchGameButton,
                onPressed: !loading ? cubit.searchMatch : null,
              ),
              secondaryAction: .new(
                label: t.home.leaveLobbyButton,
                onPressed: !loading ? cubit.leaveLobby : null,
              ),
            ),

            Lobby(state: .searching) => BasicLayout(
              body: GameDataBody(
                queueName: queueName,
                title: t.gameState.lobbySearchingTitle,
                description: t.gameState.lobbySearchingDescription,
                tone: .active,
                icon: Icons.radar_outlined,
              ),
              action: .new(
                label: t.home.cancelSearchButton,
                onPressed: !loading ? cubit.stopMatchSearch : null,
              ),
            ),

            Found(state: .pending, :var answerMaxTime, :var answerTimeLeft) => BasicLayout(
              body: GameDataBody(
                queueName: queueName,
                title: t.gameState.foundPendingTitle,
                description: t.gameState.foundPendingDescription,
                tone: .ready,
                icon: Icons.notifications_active_outlined,
                child: GameFoundCountdown(maxTime: answerMaxTime, timeLeft: answerTimeLeft),
              ),
              action: .new(
                label: t.home.acceptGameButton,
                onPressed: !loading ? cubit.acceptMatch : null,
              ),
              secondaryAction: .new(label: t.home.declineGameButton, onPressed: cubit.declineMatch),
            ),

            Found(state: .accepted) => BasicLayout(
              body: GameDataBody(
                queueName: queueName,
                title: t.gameState.foundAcceptedTitle,
                description: t.gameState.foundAcceptedDescription,
                tone: .ready,
                icon: Icons.check_circle_outline,
              ),
              loading: true,
            ),

            Found(state: .declined) => BasicLayout(
              body: GameDataBody(
                queueName: queueName,
                title: t.gameState.foundDeclinedTitle,
                description: t.gameState.foundDeclinedDescription,
                tone: .warning,
                icon: Icons.cancel_outlined,
              ),
              loading: true,
            ),

            ChampionSelect() => ChampionSelectComponent.builder(
              queueName: queueName,
              championSelect: state,
            ),

            InGame() => BasicLayout(
              body: GameDataBody(
                queueName: queueName,
                title: t.gameState.inGameTitle,
                description: t.gameState.inGameDescription,
                tone: .active,
                icon: Icons.videogame_asset_outlined,
              ),
            ),

            Unknown() => BasicLayout(
              body: GameDataBody(
                queueName: queueName,
                title: t.gameState.unknownTitle,
                description: t.gameState.unknownDescription,
                tone: .warning,
                icon: Icons.help_outline,
              ),
            ),
          },
        },
      ),
    );
  }

  void _vibrateOnStateChange(GameState previous, GameState current) {
    bool stateMatches<T extends RemoteRiftState>(
      GameState gameState,
      bool Function(T value)? predicate,
    ) {
      if (gameState case Data(:T state)) {
        if (predicate == null || predicate(state)) {
          return true;
        }
      }
      return false;
    }

    bool changedTo<T extends RemoteRiftState>({bool Function(T value)? matching}) {
      return !stateMatches(previous, matching) && stateMatches(current, matching);
    }

    if (changedTo<Lobby>(matching: (value) => value.state == .searching) || changedTo<InGame>()) {
      vibrateMillis(100);
    } else if (changedTo<Unknown>()) {
      vibrateMillis(300);
    } else if (changedTo<Found>(matching: (value) => value.state == .pending)) {
      vibrateMillis(500);
    }
  }
}
