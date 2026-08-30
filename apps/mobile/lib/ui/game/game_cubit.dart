import 'dart:async';

import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import '../../data/api_client.dart';
import 'game_state.dart';

class GameCubit({
  required final RemoteRiftApiClient _apiClient,
}) extends Cubit<GameState> {
  this : super(Loading());

  final _retryBackoff = RetryBackoff.standard;
  CancelableStream<RemoteRiftSession>? _gameSessionStream;
  Timer? _retryTimer;
  var _sessionRevision = 0;
  AsyncCallback? _retryAction;

  void initialize() {
    _listenGameStateWithRetry();
  }

  void dispose() {
    _stopGameStateStream();
  }

  void createLobby({required int queueId}) {
    _runGameAction(.createLobby, () async {
      await _apiClient.createLobby(queueId: queueId);
    });
  }

  void searchMatch() {
    _runGameAction(.searchMatch, () async {
      await _apiClient.searchMatch();
    });
  }

  void leaveLobby() {
    _runGameAction(.leaveLobby, () async {
      await _apiClient.leaveLobby();
    });
  }

  void updateLobbyRolePreferences({
    required LobbyRole first,
    required LobbyRole second,
  }) {
    _runGameAction(.updateRoles, () async {
      await _apiClient.updateLobbyRolePreferences(first: first, second: second);
    });
  }

  void stopMatchSearch() {
    _runGameAction(.stopSearch, () async {
      await _apiClient.stopMatchSearch();
    });
  }

  void acceptMatch() {
    _runGameAction(.acceptMatch, () async {
      await _apiClient.acceptMatch();
    });
  }

  void declineMatch() {
    _runGameAction(.declineMatch, () async {
      await _apiClient.declineMatch();
    });
  }

  Future<void> _listenGameStateWithRetry() async {
    try {
      await _listenGameState();
    } on RemoteRiftApiError {
      _retryTimer = Timer(_retryBackoff.tick(), _listenGameStateWithRetry);
    }
  }

  Future<void> _listenGameState() async {
    final stream = _apiClient.getCurrentSessionStream().cancelable();
    _gameSessionStream = stream;

    await for (var gameSession in stream) {
      _sessionRevision++;
      _retryAction = null;
      emit(Data(queueName: gameSession.queueName, state: gameSession.state));
    }
  }

  void _stopGameStateStream() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _gameSessionStream?.cancel();
    _gameSessionStream = null;
  }

  void retry() {
    _retryAction?.call();
  }

  Future<void> _runGameAction(GameAction actionType, AsyncCallback action) async {
    final currentState = switch (state) {
      Data data => data,
      _ => throw StateError(
        'Tried to run game action while not connected to the game api (was ${state.runtimeType})',
      ),
    };
    final requestRevision = _sessionRevision;
    _retryAction = null;

    try {
      emit(currentState.copyWith(loading: true, failedAction: null));
      await action();
    } catch (_) {
      if (requestRevision != _sessionRevision || state is! Data) {
        return;
      }
      _retryAction = () => _runGameAction(actionType, action);
      emit(currentState.copyWith(loading: false, failedAction: actionType));
      return;
    }
    final latestState = state;
    if (requestRevision != _sessionRevision || latestState is! Data) {
      return;
    }
    emit(latestState.copyWith(loading: false));
  }
}
