# Champion Select Status — Desktop/API implementation

## Status

The desktop connector publishes Champion Select status through the current
`0.14.0` API. This plan covers the session payload and its mapping. The command
contract is in [Desktop Phase 3](full-matchmaking-loop-desktop.md#phase-3--personal-champion-select).

## Session contract

`/session/watch` publishes `value: championSelect` during League Client Champion Select.
The state includes the normalized phase, adjusted remaining time, optional
turn, local champion and action, assigned position, and both summoner spells.
It also includes action availability and unavailable champion catalog IDs for
Mobile's controls. Champion and spell selections carry display names. The
separate catalog provides IDs used in commands.

Missing selections are nullable. Mobile uses localized placeholders. An
incomplete or unrecognized timer publishes `unknown`.

## Connector behavior

- Read `GET /lol-champ-select/v1/session` during Champion Select. Identify the
  local player by matching `localPlayerCellId` with `myTeam`.
- Read the player's preferred champion during planning. During later phases,
  resolve the local champion and pick or ban action from the active local action
  or the most recent completed local action with a champion.
- Resolve champion and spell names through the connector's `GameDataStore`,
  using `GET /lol-champ-select/v1/all-grid-champions` and
  `GET /lol-game-data/assets/v1/summoner-spells.json`. Each store caches
  successful metadata loads and coalesces concurrent loads.
- Map absent, nonpositive, or unmatched selection IDs to null. The stream
  skips polls that throw an LCU connection or client error directly. Parallel
  metadata lookups can wrap a read error and terminate the stream.
- Poll at one-second intervals and suppress duplicate sessions. Gameplay and
  post-game continue to publish the existing `inGame` state.

## Verification

- Inspect `/session/watch` during planning, ban/pick, gameplay and post-game.
- Check the nullable selection fields, normalized timer, and action availability
  when local player data is incomplete.
- Compare selected display names with catalog entries. Verify recovery after a
  direct LCU read failure and inspect stream closure separately when a parallel
  metadata lookup fails.

## Assumptions

- The connector owns LCU reads and mapping. Mobile formats the countdown and
  localizes the display labels and placeholders.
