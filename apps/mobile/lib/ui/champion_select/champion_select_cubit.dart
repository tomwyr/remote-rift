import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import '../../data/api_client.dart';
import '../../data/champion_select_catalog.dart';
import 'champion_select_state.dart';

class ChampionSelectCubit({
  required final RemoteRiftApiClient _apiClient,
  required ChampionSelect championSelect,
}) extends Cubit<ChampionSelectState> {
  this : super(Initial(championSelect: championSelect));

  final _events = StreamController<ChampionSelectEvent>();
  Stream<ChampionSelectEvent> get events => _events.stream;

  Future<void> loadCatalog() async {
    final championSelect = state.championSelect;
    emit(Loading(championSelect: championSelect));
    try {
      final catalog = await _apiClient.getChampSelectCatalog();
      emit(Data(championSelect: championSelect, catalog: catalog.sorted()));
    } catch (_) {
      emit(Failed(championSelect: championSelect));
    }
  }

  void updateChampionSelect(ChampionSelect championSelect) {
    emit(switch (state) {
      Initial() => Initial(championSelect: championSelect),
      Loading() => Loading(championSelect: championSelect),
      Failed() => Failed(championSelect: championSelect),
      Data data => data.copyWith(championSelect: championSelect),
    });
  }

  Future<void> pickChampion({required int championId}) async {
    await _runAction(.pickChampion, () async {
      await _apiClient.pickChampion(championId: championId);
    });
  }

  Future<void> banChampion({required int championId}) async {
    await _runAction(.banChampion, () async {
      await _apiClient.banChampion(championId: championId);
    });
  }

  Future<void> changeSummonerSpell({
    required int spellId,
    required ChampionSelectSummonerSpellSlot slot,
  }) async {
    final ChampionSelectAction action = switch (slot) {
      .first => .firstSpell,
      .second => .secondSpell,
    };
    await _runAction(action, () async {
      await _apiClient.changeSummonerSpell(spellId: spellId, slot: slot);
    });
  }

  Future<void> lockIn() async {
    await _runAction(
      .lockIn,
      _apiClient.lockInChampion,
      completedEvent: .lockedIn,
    );
  }

  Future<void> _runAction(
    ChampionSelectAction action,
    AsyncCallback operation, {
    ChampionSelectEvent completedEvent = .actionCompleted,
  }) async {
    if (!_beginAction(action)) {
      return;
    }

    try {
      await operation();
      _finishAction(action);
      _events.add(completedEvent);
    } catch (_) {
      _finishAction(action, failed: true);
    }
  }

  bool _beginAction(ChampionSelectAction action) {
    final currentData = switch (state) {
      final Data data => data,
      _ => null,
    };

    if (currentData == null || currentData.statusOf(action) == .submitting) {
      return false;
    }

    final actionStatuses = {...currentData.actionStatuses};
    actionStatuses[action] = .submitting;
    emit(currentData.copyWith(actionStatuses: actionStatuses));
    return true;
  }

  void _finishAction(ChampionSelectAction action, {bool failed = false}) {
    final currentData = switch (state) {
      final Data data => data,
      _ => null,
    };

    if (currentData == null) {
      return;
    }

    final actionStatuses = {...currentData.actionStatuses};
    if (failed) {
      actionStatuses[action] = .failed;
    } else {
      actionStatuses.remove(action);
    }
    emit(currentData.copyWith(actionStatuses: actionStatuses));
  }

  @override
  Future<void> close() async {
    await _events.close();
    await super.close();
  }
}
