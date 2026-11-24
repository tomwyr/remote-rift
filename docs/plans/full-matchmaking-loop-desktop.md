# Full Matchmaking Loop — Desktop

Desktop connects to the League Client, publishes the live session, and validates
commands from Mobile. The session foundation, lobby roles, and personal champion
select are implemented. Resilience verification and the documented stream gaps
remain open. Desktop advertises connector API `0.14.0`.

See the [Mobile plan](full-matchmaking-loop-mobile.md) for the companion flow
and the pending website update.

- [Phase 1 — Actionable Session Foundation](#phase-1--actionable-session-foundation)
- [Phase 2 — Lobby Role Preferences](#phase-2--lobby-role-preferences)
- [Phase 3 — Personal Champion Select](#phase-3--personal-champion-select)
- [Phase 4 — End-to-End Resilience](#phase-4--end-to-end-resilience)

## Phase 1 — Actionable Session Foundation

### Summary

Establish the Desktop-owned champion-select capability contract. Desktop reads
LCU gameflow and champion-select state. The existing session stream publishes
which personal actions Mobile can offer. Desktop Phase 3 adds the commands
that use the same availability rules.

### Key changes

- Decode the LCU action assignments and find the active, incomplete action for
  `localPlayerCellId`. Keep raw player and action identifiers and LCU
  credentials inside the connector.
- Include `ChampionSelectActionAvailability` in `ChampionSelect`. It carries
  separate flags for pick, ban, lock-in, and summoner-spell changes.
- Derive availability from the live session. A missing phase or remaining time
  publishes `Unknown`. A recognized session with missing local player data or
  an expired timer makes every action unavailable. Planning enables
  pick intent and spell changes. An active local pick or ban makes that
  action and lock-in available. Without an active local pick or ban, the
  non-planning branch permits spell changes.
- Use the shared action enum to check availability at the connector boundary.
  The mutations introduced in Phase 3 complete with `Future<void>` and throw
  typed state errors for unavailable or rejected requests. Session payloads
  carry capabilities without command results.
- Serialize availability with the session state and include it in value
  equality. `/session/watch` publishes a new snapshot when availability
  changes. The foundation shipped with connector API `0.13.0`; the current
  API is `0.14.0` after the game-client launch addition.

### Validation

- Inspect session payloads during planning, a local pick or ban, another
  player's turn, and expiry. Confirm each variant carries the expected flags.
- Confirm missing local player data disables all actions and unsupported or
  incomplete timer data yields the appropriate non-actionable state.
- Confirm existing non-champion-select session variants still decode.

### Assumptions

- HTTP command routes and LCU mutations are covered by
  [Desktop Phase 3](#phase-3--personal-champion-select).
- The action set covers personal champion and spell changes. Team controls,
  trades, party controls, and ARAM-specific mechanics remain out of scope.

## Phase 2 — Lobby Role Preferences

### Summary

Desktop exposes the local player's lobby role preferences through the shared
session stream and accepts updates through the local API.

### Shared session contract

- `Lobby` carries nullable role preferences. The available variants are
  `unselected`, `fill`, and `selection`, with first and second roles on
  `selection`.
- Input roles are top, jungle, middle, bottom, and support. The connector maps
  the LCU utility role to support and reverses the mapping when submitting.
- The session omits useful role preferences when the lobby has no position
  selector, local member data is missing, or the LCU pair cannot be mapped to
  one of the supported variants.

### Desktop connector

- Read the current lobby, its `gameConfig.showPositionSelector` flag, and the
  preferences reported for its local member. The position selector determines
  whether the current lobby supports role controls.
- Update preferences through
  `PUT /lol-lobby/v2/lobby/members/localMember/position-preferences` using the
  selected first and second LCU roles.
- Before writing, validate that the roles differ, the live gameflow phase is
  lobby, a lobby exists, and its position selector is enabled. Raise a typed
  state error when a precondition fails.

### Local API

- `POST /lobby/role-preferences` accepts a JSON `RolePreferenceInput` body
  containing `first` and `second`.
- Missing, malformed, or duplicate inputs return `400`. The connector checks
  the live lobby before performing the write. Success returns `204` and the
  updated preferences arrive through the next changed session snapshot.
- Generated serializers encode the role values and the session variants. The
  feature shipped in connector API `0.13.0` and remains in `0.14.0`.

### Manual verification

- In a lobby with a position selector, inspect the published unselected,
  fill, or selected state and verify it matches the League Client.
- Submit a valid pair. Confirm the League Client updates it and the next
  changed session snapshot reports the pair.
- Check that lobbies without a position selector and gameflow outside an
  idle lobby cannot receive a role update.
- Check that malformed, missing, duplicate, and stale requests leave the
  League Client settings intact.

### Constraints

- This phase covers the Desktop connector and local API. The corresponding
  Mobile flow is covered by [Mobile Phase 2](full-matchmaking-loop-mobile.md#phase-2--lobby-role-preferences).
- Party management and queue-specific mechanics remain out of scope.

## Phase 3 — Personal Champion Select

### Summary

Implement the Desktop connector and local API commands for the signed-in
player's pick intent, picks, bans, lock-in, and individual summoner-spell
changes. The Desktop Phase 1 availability model governs personal actions.

### Key changes

- Use `PATCH /lol-champ-select/v1/session/actions/{actionId}` for champion
  selection, bans, and lock-in on the active local action. The ban-none
  command sends the LCU's no-champion value for an active ban.
- Use `PATCH /lol-champ-select/v1/session/my-selection` for pick intent during
  planning and individual spell changes.
- Before a mutation, re-read live gameflow and champion-select state, then
  confirm the local player and applicable availability. For an active pick or
  ban, check the local action assignment. After changing it or locking it in,
  verify the requested state through an LCU read. Verify pick intent by
  reading the local player's choice again.
- Require positive catalog IDs on the public champion and spell commands.
  The connector rejects a spell that duplicates the other slot. The LCU
  remains the authority on selection eligibility. The command path currently
  does not cross-check positive IDs against a fetched catalog.
- Keep selected champion and spell display names in the shared session
  snapshot alongside the current turn and action availability. Catalog entries
  supply command IDs. Raw LCU action and player identifiers stay internal.
- Use `GET /champ-select/catalog` during a live session with a local player
  and usable catalog data. Champion entries include `id`, `name`, and
  `isFavorite`. Spell entries include `id` and `name` and are filtered by
  the current game mode.
- Use the following typed POST commands:
  - `/champ-select/champion` with `championId` and `action` (`pick` or `ban`)
  - `/champ-select/ban-none` with no request body
  - `/champ-select/lock-in` with no request body
  - `/champ-select/spell` with `spellId` and `slot` (`first` or `second`)
- Malformed bodies and nonpositive IDs return `400` before a mutation.
  The connector throws typed state errors when a live action is unavailable
  or rejected. At the HTTP boundary, those errors currently propagate as
  server errors. Successful mutations return `204`.
- Use the session WebSocket as the authority after each command. The HTTP
  response confirms request completion. The capability shipped in
  connector API `0.13.0` and is available in the current `0.14.0` API.

### Manual verification

- In a solo draft, check the catalog shape and game-mode spell filtering.
  Verify that outside champion select the catalog request fails.
- Exercise pick intent, pick, ban, ban-none, lock-in, and both spell slots.
  Compare each accepted action with the following live session snapshot.
- Check missing or completed local actions, expired turns, malformed input,
  duplicate spells, LCU rejections, and lost connectivity. Confirm failed
  requests do not alter another player's selection.

### Assumptions

- Desktop Phase 1 supplies live per-action availability. Mobile consumes the
  status stream and renders the command affordances described in
  [Mobile Phase 3](full-matchmaking-loop-mobile.md#phase-3--personal-champion-select).
- Team actions, trades, ARAM mechanics, rerolls, skins, portraits, position
  changes, and party controls remain outside this phase.

## Phase 4 — End-to-End Resilience

### Summary

Harden the Desktop connector across lobby, matchmaking, ready check, and
champion select. The shared session stream is authoritative. Commands check
live League Client state immediately before a mutation.

### Key changes

- Build on the role preferences, action availability, catalog, and typed
  commands delivered by Desktop phases 1–3.
- Poll session state once per second and publish changed snapshots. On a direct
  `LcuConnectionError` or `LcuApiClientError`, skip the poll and reset deduplication
  so the next valid snapshot is published even when it matches the last one.
- Publish `Unknown` when a successful poll maps to an indeterminate state,
  including an invalid ready check or incomplete champion-select timer. The
  separate status stream reports connector availability and read failures.
  [Parallel champion-select metadata failures](champion-select-status-desktop-api.md)
  can close the session stream because they reach it as a wrapped error.
- Check the live game-state precondition before lobby, queue, ready-check,
  and champion-select mutations. Reject an unavailable or stale action
  through a typed state error. Champion selection and lock-in also check
  the result against a fresh LCU read.
- The LCU transport refreshes lockfile credentials and retries a request
  once on a socket error. A game-state rejection does not trigger that retry.
- Publish the next gameflow state when champion select ends. The new
  session no longer includes champion-select availability and catalog
  requests outside champion select fail. Gameplay and post-game map to
  the existing in-game state.
- Keep recovery in the existing session, status, and command contracts, with
  Mobile UI behavior covered by the matching Mobile phase.

### Manual validation

- Run a solo draft loop through lobby creation, role selection, queueing,
  ready check, champion select, gameplay, post-game, and return to pre-game.
  Compare each published session state with the live LCU state.
- During ready check and champion select, let the action expire or change the
  League Client state before submitting. Confirm the command rechecks its
  preconditions and a new snapshot replaces the stale one.
- Interrupt and restore LCU access during queueing or champion select. For a
  directly reported LCU error, check that the failed poll emits no session
  update, the status stream exposes the failure, and the next valid snapshot
  is published after recovery. Check stream closure on metadata failure separately.
- Check incomplete champion-select data and catalog requests outside champion
  select. Confirm they yield the appropriate non-actionable state or error.

### Assumptions

- A session consumer may still have the last snapshot when a poll is skipped.
  Transport recovery and command-time validation cover different parts of
  that interval. Explicitly replacing the snapshot on LCU read failures
  is outside the current session behavior.
- This phase adds resilience to the existing draft flow. Team and party
  controls, trades, and ARAM-specific mechanics remain out of scope.
