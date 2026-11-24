# Local MCP server

## Goal

Add an optional, local-only Model Context Protocol server to Remote Rift Desktop.
It lets a user connect a desktop AI host to the running connector and request
existing Remote Rift actions in natural language. The AI host interprets the
message. Remote Rift receives only typed MCP tool calls and delegates them to
the existing connector domain API.

This is a power-user Desktop integration. It does not add an AI model, chat UI,
cloud service, or recurring model cost to Remote Rift.

## Product boundary

The MCP server is separate from the mobile-facing API:

- it listens only on the loopback interface and is never advertised with mDNS;
- it starts after the Desktop user enables it or on a subsequent launch when
  the user has enabled automatic startup;
- it exposes a narrow, product-level tool set, never raw LCU requests,
  lockfile credentials, local filesystem access, or process execution;
- it uses the same `RemoteRiftConnector` operations that power the current
  service instead of calling API routes or LCU clients directly;
- the user brings a compatible AI host. Remote Rift does not send user prompts
  to an LLM or require an API key.

The server uses Streamable HTTP, so the running Desktop application owns the
listener and presents its connection details to the AI host. It binds to
`127.0.0.1` on a dedicated port with path `/mcp`. The default port is
`46321`, and package callers can supply a different port.

## Package structure

`packages/mcp` belongs to the root Pub workspace as `remote_rift_mcp`.

The Dart VM package depends on `mcp_dart` and `remote_rift_core`. Its public
API exposes a server controller independent of Desktop UI and discovery.

Its public surface consists of:

- `RemoteRiftMcpServer`, constructed with a connector, bearer secret, and
  optional port. `start()` returns the bound endpoint as a `Uri`, `stop()`
  closes the transport, and `isRunning` reports the lifecycle state.
- `RemoteRiftMcpServerError` and typed bind, start, and stop errors.

Keep MCP schemas, tool registration, result mapping, and authentication inside
this package. Do not let MCP SDK types escape into `remote_rift_core`.

## MCP contract

Register each operation explicitly with a clear, action-oriented name and
input schema. Describe required game state in the tool description, but keep
the existing connector validation authoritative.

### Read tools

- `get_server_status`: report the MCP listener's lifecycle state.
- `get_connection_status`: return the current connector availability.
- `get_session`: return the current queue name and normalized gameflow state,
  including ready-check and champion-select data when present.
- `list_queues`: return queues from the pre-game session state; report that
  queues are unavailable outside pre-game rather than synthesizing data.
- `get_champion_select_catalog`: return the champion grid and game-mode-filtered
  summoner spells during Champion Select. The live session separately reports
  unavailable champion IDs.

### Action tools

- `create_lobby(queue_id)`, `leave_lobby()`, and
  `set_role_preferences(first, second)`.
- `start_matchmaking()` and `stop_matchmaking()`.
- `accept_ready_check()` and `decline_ready_check()`.
- `select_champion(action, champion_id)`, `ban_no_champion()`,
  `set_summoner_spell(slot, spell_id)`, and `lock_in_champion()`.

Map `RemoteRiftStateError` to stable, actionable MCP tool errors. Propagate
unexpected infrastructure failures as failed calls without treating them as a
valid game state. Successful mutations return structured content with the action
name and `completed: true`. The host can request a fresh normalized session
snapshot.

Do not provide a generic `call_endpoint`, a raw JSON tool, or unrestricted
arguments. New product actions require new tools.

## Authorization

On the first enable, create a cryptographically secure bearer secret and store
it in platform secure storage. Reuse that secret whenever Remote Rift Desktop
or League starts again, so the user configures their AI host once. Require it
for every MCP request, including reads.

After the server is active, Desktop offers a configuration sheet with a
copy action. The snippet includes the endpoint and bearer header for the AI
host to send with each request. Keep the secret within this setup flow and
secure storage. Disabling the server stops the listener and preserves the
pairing. **Reset access** restarts it with a new stored secret, requiring the
user to copy the new configuration.

Every mutation, including ready-check acceptance/decline and champion lock-in,
executes directly through the AI host. Existing connector validation remains
authoritative for every call. The Desktop app configures and runs the local
server; it does not mediate game actions.

## Desktop lifecycle and UI

The Desktop app's `McpServerRunner` owns one `RemoteRiftMcpServer`, creates it
on enable, and returns the endpoint and generated host configuration. The
cubit closes the runner through the app exit lifecycle.

`McpScope` owns `McpIntegrationCubit` across Desktop pages. The cubit loads
the start-on-launch preference and starts the listener automatically when both
previously enabled and configured to start on launch. On a fresh install,
start-on-launch defaults to on and the listener waits for the first enable.

The **MCP server** card in Desktop Settings provides:

- a local-only explanation and enable, disable, and reset actions;
- idle, starting, running, resetting, stopped, and error states;
- an automatic-start toggle and a details sheet with a copyable host snippet.

The Desktop footer shows MCP status during start, reset, and active operation.
Visible labels come from the Desktop Slang source. The copied configuration
uses a generic HTTP format with `type`, `url`, and `headers` fields. The
[package README](../../packages/mcp/README.md) describes setup for a compatible
local host.

## Implementation sequence

1. Add `packages/mcp` to the workspace and create its package manifest, public
   library, `mcp_dart` dependency, and server lifecycle/controller API.
2. Implement loopback Streamable HTTP, bearer authorization, and start/stop
   cleanup. Return the bound endpoint from the server controller.
3. Register read tools against `RemoteRiftConnector` and use its on-demand
   normalized session for current state. Keep LCU mapping in Core.
4. Register typed action tools, map expected domain errors, and return a
   successful completion result after each mutation.
5. Add secure secret storage, the Desktop runner, feature-local cubit/state,
   integration UI, copied configuration, explicit pairing reset, localization,
   and app-exit cleanup.
6. Document setup, local-only behavior, and bearer authentication. Keep
   host-specific setup in deferred work.

## Verification

After implementation, run the relevant Dart formatter and analyzer only. Do
not add or run tests unless explicitly requested.

Perform a manual Desktop smoke check:

1. Launch Desktop with MCP disabled and confirm its existing connector and
   mobile LAN API behavior is unchanged.
2. Enable MCP and confirm it binds only to `127.0.0.1` on its dedicated port,
   produces a usable configuration, and rejects requests without the secret.
3. Connect a compatible local AI host and confirm read tools expose the
   current state and ordinary actions obey existing game-state guards.
4. Confirm ready-check and lock-in execute through the AI host and fail safely
   when the game state is no longer valid.
5. Restart Desktop with automatic startup on and confirm the saved host
   configuration still authenticates. Turn automatic startup off and confirm
   the next launch leaves the listener stopped. Check that disabling stops the
   endpoint and resetting allows only the new configuration to authenticate.

## Deferred work

- Packaging the integration as a Claude Desktop extension.
- Host-specific configuration and installation flows.
- Remote access, mDNS advertisement, cloud relay, and mobile consumption.
- An in-app chat UI or provider-backed AI model.
