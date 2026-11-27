# Remote Rift Simulator implementation plan

Implement the [simulator PRD](../prds/league-client-simulator.md) in
`apps/simulator`. Keep the simulator's server, state machine,
and controls in that app. Desktop's existing lockfile setting selects the
simulated server for connection status and MCP.

## Phase 1 — Define the protocol boundary and scaffold the app

1. Expose the existing League Client wire models through
   `packages/core/lib/lcu_protocol.dart`. Add a typed lobby-create request and
   an explicit gameflow phase encoder backed by the generated wire values.
2. Add a Flutter workspace member with macOS and Windows runners and a
   `just simulator-run <device>` recipe. Put route definitions, fixtures,
   and simulation dependencies in the simulator app.
3. Keep Desktop, Mobile, and the production Connector's behavior intact.
   Desktop's bundled Connector continues to use the platform-default
   lockfile for Mobile. A development Connector is separate from this work.

## Phase 2 — Serve the League Client API

1. Bind an authenticated HTTPS listener to `127.0.0.1` on an available port
   with a self-signed certificate. Generate fresh credentials for each
   startup and use the League Client's `riot` Basic authentication username.
2. Once the listener is ready, stage and rename
   `league-client-simulator.lockfile` in the simulator's application support
   directory. Write `LeagueClientSimulator:<pid>:<port>:<password>:https`.
   On shutdown, close the listener and remove the lockfile if it still belongs
   to that instance. Clean up the listener and staging file on failed startup.
3. Register Shelf routes that match the existing League Client API client.
   Return JSON for reads and `204` for successful mutations. Check
   authentication before dispatch, report `503` while offline, and distinguish
   malformed inputs from actions that are invalid in the current phase.

| API area | Operations to serve |
| --- | --- |
| Client and gameflow | Application name, gameflow phase, session, and queues |
| Lobby and search | Read, create, or leave a lobby, read or update role preferences, and read, start, or cancel search |
| Ready check | Read status and answer accept or decline |
| Champion select | Read the session, champion grid, and spells, and patch champion actions or local spell selection |

## Phase 3 — Model gameflow and outcomes

1. Let `Simulator` own the lobby, active stage, and timers. Expose snapshots to
   the UI and map each internal stage to its League Client gameflow phase.
   Reject body-backed mutations if the stage changes while decoding.
2. Provide Normal Draft Pick (queue 400) and ARAM (queue 450). Allow role
   preferences in an idle Draft lobby. Starting search opens a ready check
   after six seconds or on manual advance. The check expires after ten
   seconds. Keep an answered check visible for two seconds before transitioning.
   Acceptance enters champion select. Decline, expiry, and a scripted
   other-player decline return to the lobby.
3. For Draft, expose the pending pick action during planning so hover updates
   appear as pick intent. Follow planning with local ban, scripted enemy ban,
   teammate pick, enemy pick, and local pick. Carry the intent into local
   pick if the champion is still available. A local pick timeout returns to
   the lobby.
4. Start ARAM at local pick with an assigned champion. Use a small local
   champion and spell catalog with game-mode eligibility. Support spell
   changes, action lock-in, and no ban where applicable. On a completed
   pick or ARAM timeout, advance through finalization and game start to
   in-game and end-of-game phases, then return to the same lobby.
5. Use the stage timer to drive automatic transitions. Give the UI a
   countdown and allow manual advance, end game, and reset. Going offline
   resets the session to Home. Turning the client back on restores access to
   the same listener and lockfile.

## Phase 4 — Present controls and verify

1. Let the simulator page own its Cubit. Start the server from the page
   lifecycle, subscribe to simulator snapshots, and close the subscription,
   server, and timers on disposal. Show a copyable lockfile path on success
   and retryable startup errors for listener or lockfile failures.
2. Render the queue, stage, countdown, and actions available in each state.
   Keep labels and recovery messages in the simulator's localization source.
   Document the run and connection workflow in the
   [simulator README](../../apps/simulator/README.md).
3. Format and analyze the affected Dart code. On an available desktop host,
   run the simulator, select its lockfile in Desktop, and confirm Desktop
   status and MCP queue discovery. Exercise Draft through lock-in and ARAM
   through game completion, plus ready-check decline, timeout, and recovery
   after taking the client offline.
4. Reset Desktop's lockfile location and confirm it uses the platform-default
   League Client path. Verify that Mobile discovery and production Connector
   routing match the base branch.
