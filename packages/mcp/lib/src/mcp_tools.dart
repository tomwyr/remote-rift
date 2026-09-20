import 'package:mcp_dart/mcp_dart.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import 'mcp_server.dart';

part 'mcp_tools_support.dart';

extension RemoteRiftMcpTools on McpServer {
  void configure(
    RemoteRiftMcpServer server,
    RemoteRiftConnector connector,
  ) {
    register(
      name: 'get_server_status',
      description: 'Get the MCP server lifecycle status.',
      (args) async => {'is_running': server.isRunning},
    );

    register(
      name: 'get_connection_status',
      description: 'Get the League Client connection status.',
      (args) async {
        final status = await connector.getStatus();
        return status.toJson();
      },
    );

    register(
      name: 'get_session',
      description: 'Get the current normalized game session.',
      (args) async {
        final session = await connector.getCurrentSession();
        return session.toJson();
      },
    );

    register(
      name: 'list_queues',
      description: 'List queues available before a lobby is created.',
      (args) async {
        final session = await connector.getCurrentSession();
        if (session.state case PreGame(:var availableQueues)) {
          return {'queues': availableQueues.map((queue) => queue.toJson()).toList()};
        }
        throw RemoteRiftStateError.notPreGame;
      },
    );

    register(
      name: 'get_champion_select_catalog',
      description: 'List eligible champions and summoner spells during champion select.',
      (args) async {
        final catalog = await connector.getChampionSelectCatalog();
        return catalog.toJson();
      },
    );

    register(
      name: 'create_lobby',
      description: 'Create a lobby for a queue before matchmaking.',
      properties: {'queue_id': .integer()},
      (args) async {
        final queueId = args.intValue('queue_id');
        await connector.createLobby(queueId: queueId);
        return completion('create_lobby');
      },
    );

    register(
      name: 'leave_lobby',
      description: 'Leave the current idle lobby.',
      (args) async {
        await connector.leaveLobby();
        return completion('leave_lobby');
      },
    );

    register(
      name: 'set_role_preferences',
      description: 'Set primary and secondary roles in an eligible lobby.',
      properties: {'first': _roleSchema(), 'second': _roleSchema()},
      (args) async {
        final first = _role(args.stringValue('first'), 'first');
        final second = _role(args.stringValue('second'), 'second');
        await connector.updateLobbyRolePreferences(first: first, second: second);
        return completion('set_role_preferences');
      },
    );

    register(
      name: 'start_matchmaking',
      description: 'Start matchmaking from an idle lobby.',
      (args) async {
        await connector.searchMatch();
        return completion('start_matchmaking');
      },
    );

    register(
      name: 'stop_matchmaking',
      description: 'Stop active matchmaking.',
      (args) async {
        await connector.stopMatchSearch();
        return completion('stop_matchmaking');
      },
    );

    register(
      name: 'accept_ready_check',
      description: 'Accept the active ready check.',
      (args) async {
        await connector.acceptMatch();
        return completion('accept_ready_check');
      },
    );

    register(
      name: 'decline_ready_check',
      description: 'Decline the active ready check.',
      (args) async {
        await connector.declineMatch();
        return completion('decline_ready_check');
      },
    );

    register(
      name: 'select_champion',
      description: 'Pick or ban a champion during champion select.',
      properties: {
        'champion_id': .integer(),
        'action': .string(enumValues: ['pick', 'ban']),
      },
      (args) async {
        final championId = args.intValue('champion_id');
        final action = args.stringValue('action');
        switch (action) {
          case 'pick':
            await connector.pickChampion(championId: championId);
          case 'ban':
            await connector.banChampion(championId: championId);
          case var value:
            throw ArgumentError.value(value, 'action', 'Unsupported champion action.');
        }
        return completion('select_champion');
      },
    );

    register(
      name: 'lock_in_champion',
      description: 'Lock in the selected champion.',
      (args) async {
        await connector.lockInChampion();
        return completion('lock_in_champion');
      },
    );

    register(
      name: 'set_summoner_spell',
      description: 'Set a summoner spell during champion select.',
      properties: {
        'spell_id': .integer(),
        'slot': .string(enumValues: ['first', 'second']),
      },
      (args) async {
        final spellId = args.intValue('spell_id');
        final slot = _spellSlot(args.stringValue('slot'));
        await connector.changeSummonerSpell(
          spellId: spellId,
          slot: slot,
        );
        return completion('set_summoner_spell');
      },
    );
  }

  LobbyRole _role(String value, String name) {
    return switch (value) {
      'top' => .top,
      'jungle' => .jungle,
      'middle' => .middle,
      'bottom' => .bottom,
      'support' => .support,
      _ => throw ArgumentError.value(value, name, 'Unsupported role.'),
    };
  }

  ChampionSelectSummonerSpellSlot _spellSlot(String value) {
    return switch (value) {
      'first' => .first,
      'second' => .second,
      _ => throw ArgumentError.value(value, 'slot', 'Unsupported spell slot.'),
    };
  }

  JsonSchema _roleSchema() {
    return .string(enumValues: ['top', 'jungle', 'middle', 'bottom', 'support']);
  }
}
