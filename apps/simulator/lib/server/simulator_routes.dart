import 'dart:convert';
import 'dart:io';

import 'package:remote_rift_core/lcu_protocol.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../simulation/game_catalog.dart';
import '../simulation/mappers/queue.dart';
import '../simulation/simulator.dart';
import '../simulation/simulator_queue.dart';
import 'lcu_routes.dart';

class SimulatorRoutes(final Simulator _simulator, final String _authorization) {
  Handler get handler {
    final router = Router()
      ..get(LcuRoutes.applicationName, (_) => _json('LeagueClient'))
      ..get(LcuRoutes.gameflowPhase, (_) => _json(_simulator.gameflowPhase.toJson()))
      ..get(LcuRoutes.gameflowSession, _gameflowSession)
      ..get(LcuRoutes.queues, _queues)
      ..get(LcuRoutes.lobby, (_) => _json(_simulator.lobby))
      ..post(LcuRoutes.lobby, _createLobby)
      ..delete(LcuRoutes.lobby, (_) => _perform(_simulator.leaveLobby))
      ..get(LcuRoutes.lobbyPositionPreferences, (_) => _json(_simulator.positionPreferences))
      ..put(LcuRoutes.lobbyPositionPreferences, _updatePositions)
      ..get(LcuRoutes.matchmakingSearchState, (_) => _json(_simulator.matchmakingSearch))
      ..post(LcuRoutes.matchmakingSearch, (_) => _perform(_simulator.startSearch))
      ..delete(LcuRoutes.matchmakingSearch, (_) => _perform(_simulator.stopSearch))
      ..get(LcuRoutes.readyCheck, (_) => _json(_simulator.readyCheck))
      ..post(
        LcuRoutes.acceptReadyCheck,
        (_) => _perform(() => _simulator.answerReadyCheck(.accepted)),
      )
      ..post(
        LcuRoutes.declineReadyCheck,
        (_) => _perform(() => _simulator.answerReadyCheck(.declined)),
      )
      ..get(LcuRoutes.championSelectSession, (_) => _json(_simulator.championSelectSession))
      ..get(LcuRoutes.championGrid, (_) => _json(champions))
      ..get(LcuRoutes.summonerSpells, (_) => _json(spells))
      ..patch('${LcuRoutes.championSelectActions}/<id>', _updateChampionAction)
      ..patch(LcuRoutes.championSelectLocalSelection, _updateChampionSelection);

    return (request) async {
      if (request.headers[HttpHeaders.authorizationHeader] != _authorization) {
        return Response(
          HttpStatus.unauthorized,
          headers: {HttpHeaders.wwwAuthenticateHeader: 'Basic realm="League Client Simulator"'},
        );
      }

      if (!_simulator.isOnline) {
        return Response(HttpStatus.serviceUnavailable);
      }

      try {
        return await router.call(request);
      } on SimulatorRequestError catch (error) {
        return switch (error) {
          .invalidInput => Response.badRequest(),
          .invalidState => Response(HttpStatus.conflict),
        };
      }
    };
  }

  Response _gameflowSession(Request request) {
    final session = _simulator.gameflowSession;
    return session == null ? Response.notFound(null) : _json(session);
  }

  Response _queues(Request request) {
    final queues = [for (var queue in SimulatorQueue.values) queue.toLcuQueue()];
    return _json(queues);
  }

  Future<Response> _createLobby(Request request) async {
    return await _performWithJson(request, LobbyCreateRequest.fromJson, (input) {
      final queue = SimulatorQueue.values.firstWhere(
        (queue) => queue.id == input.queueId,
        orElse: () => throw SimulatorRequestError.invalidInput,
      );
      _simulator.createLobby(queue);
    });
  }

  Future<Response> _updatePositions(Request request) async {
    return await _performWithJson(
      request,
      LobbyPositionPreferences.fromJson,
      _simulator.updatePositionPreferences,
    );
  }

  Future<Response> _updateChampionAction(Request request, String id) async {
    final actionId = int.tryParse(id);
    if (actionId == null) return Response.badRequest();
    return await _performWithJson(
      request,
      ChampSelectActionUpdate.fromJson,
      (update) => _simulator.updateChampionAction(actionId, update),
    );
  }

  Future<Response> _updateChampionSelection(Request request) async {
    return await _performWithJson(
      request,
      ChampSelectMySelectionUpdate.fromJson,
      _simulator.updateChampionSelection,
    );
  }

  Future<Response> _performWithJson<T>(
    Request request,
    T Function(Map<String, dynamic>) decode,
    void Function(T) action,
  ) async {
    // A new stage can reuse the same phase and action IDs as an earlier stage.
    final revision = _simulator.stageRevision;
    final input = await _readJson(request, decode);
    if (_simulator.stageRevision != revision) {
      throw SimulatorRequestError.invalidState;
    }
    return _perform(() => action(input));
  }

  Future<T> _readJson<T>(Request request, T Function(Map<String, dynamic>) decode) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body);
      if (json is! Map<String, dynamic>) throw SimulatorRequestError.invalidInput;
      return decode(json);
    } catch (error) {
      if (error case FormatException() || TypeError() || ArgumentError()) {
        throw SimulatorRequestError.invalidInput;
      }
      rethrow;
    }
  }

  Response _json(Object? value) {
    return Response.ok(
      jsonEncode(value),
      headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
    );
  }

  Response _perform(void Function() action) {
    action();
    return Response(HttpStatus.noContent);
  }
}
