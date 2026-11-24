# Support launching the game client from Mobile

## Goal

Let a Mobile user open the League Client on their discovered Desktop host
and enter the normal game controls when that client becomes available.

## Approach

Desktop serves a launch command backed by a core Windows and macOS launcher.
Mobile owns the request in connection state because the Desktop service is
reachable while the League Client is offline. Process start and League
readiness are separate. The launch command reports process start, and the
existing status stream reports readiness.

## File changes

| File | Responsibility |
| --- | --- |
| `packages/core/lib/src/game_client/game_client_launcher.dart` | Select the platform entry point and start a detached process. Report typed failures for unsupported platforms, missing entry points, and process-start errors. |
| `packages/core/lib/src/connector.dart` and `packages/core/lib/remote_rift_core.dart` | Inject and export `GameClientLauncher` and expose the connector's `Future<void> launchGameClient()` command. |
| `packages/api/lib/src/api/routes/router.dart` and `packages/api/lib/src/api/data/config.dart` | Serve `POST /game-client/launch` with `204` on success and advertise connector API `0.14.0`. |
| `apps/mobile/lib/data/api_client.dart` and `apps/mobile/lib/data/app_config.dart` | Post to the discovered Desktop address using the shared request-error mapping and require connector API `0.14.0`. |
| `apps/mobile/lib/ui/connection/connection_state.dart`, `connection_cubit.dart`, and `connection_component.dart` | Own and present the idle, pending, and failed launch states for an unavailable League Client. |
| `apps/mobile/lib/i18n/en.i18n.yaml` and generated Slang files | Provide localized unavailable, starting, launch, and failure copy. |

## Implementation steps

### Task 1 — Launch on the Desktop host

1. On Windows, start the standard Riot Client executable with League of
   Legends and the live patchline as arguments. On macOS, use `/usr/bin/open`
   for the standard League of Legends app in Applications.
2. Check that the target entry point exists before starting the detached
   process. Return from the connector action once process start succeeds.
   Report expected failures through `GameClientLaunchError`.
3. Keep the launcher separate from LCU. Starting the process does not require
   the lockfile and does not establish a ready League Client connection.

### Task 2 — Publish the command

1. Register `POST /game-client/launch` through `configureGameClient()` and
   return `204` after the connector launches the process.
2. Advertise `0.14.0` and use the same app-wide minimum version on Mobile.
   Older Desktop services show the update-required state before game controls
   are available.

### Task 3 — Surface the available host and offline client

1. Use the Mobile client's existing POST helper, discovered service address,
   and request-error mapping for launch.
2. Emit `UnavailableGameClient` when the connected service reports that
   League is unavailable. Show **Open Riot Client** while the launch status is
   idle or failed.
3. On tap, mark the request pending, suppress repeat taps, and start
   the 30-second timer. A handled API failure while pending ends that wait
   and presents failure feedback. If League remains unavailable when the
   timer expires, return to idle and allow another attempt.
4. A ready status cancels the wait and transitions to `Connected`. That
   transition comes from the status stream even if the launch request
   already succeeded or the timeout elapsed.

### Task 4 — Localize the launch states

Keep visible labels and messages in the English Slang source and use the
generated localization accessors in the connection component.

## Acceptance criteria

- Mobile offers the launch action on a reachable Desktop when League is offline.
- One press posts to the selected Desktop and disables the action while waiting.
- The normal Windows and macOS installation entry points start without using the
  LCU lockfile. An API failure while pending leaves Mobile on the unavailable
  client view with localized retry feedback.
- If readiness is delayed for 30 seconds, the unavailable view becomes
  actionable again. When the stream reports ready, Mobile opens the game view.
- A connector version below `0.14.0` shows the update-required view.

## Verification

1. With League stopped on Windows, discover Desktop from Mobile and select
   **Open Riot Client**. Confirm the process starts and Mobile's normal game
   state follows the ready status.
2. Repeat on macOS using the standard Applications installation.
3. Verify feedback and retry if the executable is unavailable. Check that
   the action also becomes available again if readiness takes over 30 seconds.
4. Connect Mobile to a `0.13.0` service and confirm it shows the update-required
   state.

## Risks and mitigations

- Nonstandard installations are outside the launcher lookup. An unavailable
  entry point is a typed failure. The custom LCU lockfile setting does not
  change launch paths.
- Slow startup can exceed Mobile's 30-second wait. The status stream continues
  to drive readiness after the action becomes available again. The timeout
  does not cancel an in-flight request. If the user starts another attempt,
  a late failure from the earlier request can cancel the newer timer and mark
  the new attempt as failed.
- Advertising and requiring the same API version keeps the Mobile action
  behind the connector contract that includes the command.
