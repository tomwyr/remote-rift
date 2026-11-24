# League Client Simulator

Run a local Flutter desktop app, select its lockfile in Remote Rift Desktop, and
use Remote Rift Mobile through the Desktop app's existing Connector service.

## Phase 1 — Connect through the lockfile

1. Add the simulator to the Flutter workspace with macOS and Windows runners.
2. Start an authenticated HTTPS listener on loopback and write an LCU-format
   lockfile in a simulator-owned application support directory.
3. Use the Desktop app's selected lockfile for its mobile-facing Connector
   routes as well as its connection status and MCP integration.

## Phase 2 — Simulate matchmaking

1. Implement heartbeat, gameflow, queue discovery, lobby creation and removal,
   and Draft role preferences.
2. Simulate search, cancellation, a timed ready check, acceptance, decline,
   expiry, and a configurable other-player decline.
3. Support a standby mode that can be resumed by Remote Rift's launch action.

## Phase 3 — Simulate champion select and game completion

1. Supply local champion and spell catalogs for Draft and ARAM.
2. Simulate champion intent, bans, picks, lock-in, spell changes, and scripted
   teammate and opponent turns.
3. Advance through finalization, a simulated game, and return to lobby.

## Phase 4 — Operate and verify the simulator

1. Show connection details, current phase, remaining time, and scenario controls
   in the simulator desktop window.
2. Document how to connect both Remote Rift apps and reproduce common flows.
3. Format and analyze the affected Dart code, launch the simulator on the
   available desktop host, and reload Flutter after code changes.

The simulator uses a small offline roster and focuses on the League Client API
surface used by Remote Rift. It represents in-game status without running a
match or contacting Riot services.
