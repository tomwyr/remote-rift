# Remote Rift MCP

Local [Model Context Protocol](https://modelcontextprotocol.io/) server for Remote Rift.

## Overview

Remote Rift MCP lets an AI host read the current League Client state and manage lobbies, matchmaking, ready checks, and Champion Select.

When active, Remote Rift MCP makes the connector available as a set of discoverable tools. An AI host can inspect game state and issue supported actions through MCP tool calls, receiving structured results or state-specific errors.

## Usage

Create the connector and server, then start it with a caller-owned bearer token:

```dart
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_mcp/remote_rift_mcp.dart';

final server = RemoteRiftMcpServer(
  connector: RemoteRiftConnector(),
  bearerSecret: '<secret>',
);

final endpoint = await server.start();
```

Connect from an MCP-compatible host running on the same computer. Include the bearer token when configuring the connection:

```json
{
  "type": "http",
  "url": "http://127.0.0.1:46321/mcp",
  "headers": {
    "Authorization": "Bearer <secret>"
  }
}
```

> [!important]
> Treat the bearer token as a secret. Generate, store, and rotate it in the caller.

## Available tools

- `get_server_status` checks whether the Remote Rift MCP server is running.
- `get_connection_status` and `get_session` read the League Client connection and game state.
- `list_queues` and `create_lobby` list available queues and create a lobby.
- `leave_lobby`, `set_role_preferences`, `start_matchmaking`, and `stop_matchmaking` manage an idle lobby and matchmaking.
- `accept_ready_check` and `decline_ready_check` respond to an active ready check.
- `get_champion_select_catalog`, `select_champion`, `lock_in_champion`, and `set_summoner_spell` support Champion Select.

Each action validates that the League Client is in the required state and returns an MCP tool error when it is not available.

## Dependencies

This section describes selected third-party packages used throughout the project:

- [mcp_dart](https://pub.dev/packages/mcp_dart) - Dart implementation of the Model Context Protocol used to host the server and register tools.
