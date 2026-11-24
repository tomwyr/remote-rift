# Full Matchmaking Loop — Mobile

Mobile lets a solo player move from lobby setup through ready check and personal
champion select. Mobile sends commands to the Desktop connector and displays
the resulting live session. Mobile requires connector API `0.14.0`.

The main flow is implemented. Some request and picker handling remains open,
and the public website update is pending. See the
[Desktop plan](full-matchmaking-loop-desktop.md) for the connector contract.

- [Phase 1 — Actionable Session Foundation](#phase-1--actionable-session-foundation)
- [Phase 2 — Lobby Role Preferences](#phase-2--lobby-role-preferences)
- [Phase 3 — Personal Champion Select](#phase-3--personal-champion-select)
- [Phase 4 — End-to-End Resilience](#phase-4--end-to-end-resilience)
- [Phase 5 — Website Update for the Full Draft Loop](#phase-5--website-update-for-the-full-draft-loop)

## Phase 1 — Actionable Session Foundation

### Summary

Consume Desktop's player-only champion-select capabilities in a feature-local
Cubit. This phase establishes the status and availability contract used by the
interactive controls in [Mobile Phase 3](#phase-3--personal-champion-select).
Mobile currently requires connector API version `0.14.0`.

### Key changes

- Read typed champion-select availability from the live session. It covers
  pick intent or pick, ban, lock-in, and one availability flag shared by both
  spell slots.
- Keep selection and availability in the session payload. Commands use
  HTTP success or failure, separate from the live session stream.
- Scope `ChampionSelectCubit` to the champion-select component and forward the
  latest champion-select snapshot through its builder. `GameCubit` continues
  to own the overall session stream.
- Use the current phase and availability to distinguish actionable controls
  from display-only status. The later phase provides the picker and command UI.

### Validation

- Manually verify compatible-session updates reach the feature-local cubit
  and that leaving champion select disposes it.
- Confirm that a Desktop connector below `0.14.0` shows Mobile's existing
  update-required state.

### Assumptions

- Desktop publishes the availability associated with the current session.
  Mobile uses it to choose controls, and Desktop rechecks it before mutation.
- The current version gate is app-wide and includes the later client-launch
  route. The draft-loop feature originally targeted connector API `0.13.0`.

## Phase 2 — Lobby Role Preferences

### Summary

Display League role preferences in Mobile's idle lobby and let the player
submit a pair. The live session stream remains the source of the displayed
preferences after each request.

### Shared contract and Desktop connector

- The nullable `Lobby.rolePreferences` value distinguishes an unselected
  pair, fill, and a distinct selected pair. The roles are top, jungle, middle,
  bottom, and support. The connector maps support to LCU's `UTILITY`.
- In an idle lobby, the connector uses the live lobby's position-selector
  flag and the local member's preferences. Unsupported lobbies, missing
  members, and invalid pairs have no preference value. Searching and other
  game states have no preference controls.
- To update the pair, the connector writes LCU's `firstPositionPreference`
  and `secondPositionPreference` through `PUT`
  `/lol-lobby/v2/lobby/members/localMember/position-preferences`.
- Mobile sends a JSON body with `first` and `second` to
  `POST /lobby/role-preferences`. Invalid, missing, or duplicate values get
  `400`. The connector checks the live idle lobby before writing, and the
  API returns `204` on success.
- The generated serializers encode the shared values. Mobile currently
  requires connector API `0.14.0`, including the later client-launch route.

### Mobile interaction

- `GameCubit` submits the complete pair through the API client. Game-level
  loading disables role selection, Search Game, and Leave Lobby until the
  request settles or a newer session arrives.
- In the idle-lobby Role Preferences card, an unselected or fill value shows
  one entry point. The Primary sheet is followed by the Secondary sheet,
  which omits the first role. Completing both sends the pair. Canceling
  either sheet leaves the existing preferences in place.
- An existing pair appears as Primary and Secondary rows with localized
  labels, current roles, and chevrons. Each sheet marks its current role
  and permits selecting the other slot's role to swap the pair.
- Search Game is available from any idle lobby with no game action pending,
  including before a pair is selected. The card appears only for a published
  preference value in an idle lobby.
- Use the existing card and bottom-sheet components. Labels and guidance
  come from Mobile's English Slang source and generated accessors.

### Verification

- In a lobby with a position selector, open the two initial sheets and verify
  the second excludes the first choice. Confirm the reported pair changes
  after the League Client reports the new preferences.
- Change either selected role and select the other slot's role to verify
  swapping. Verify that failure restores the idle-lobby controls.
- Check that a lobby without position selection and all non-idle states hide
  the role preference card.

### Constraints

- The controls update the local player's preferences. Party management,
  champion trades, ARAM mechanics, and other queue-specific controls remain
  outside this phase.

## Phase 3 — Personal Champion Select

### Summary

Provide the local player's champion-select controls on Mobile. Desktop supplies
the catalog and executes the commands. The live session remains the source of
truth for selections, action availability, and phase changes.

### Prerequisites and compatibility

- Desktop Phase 1 publishes the typed availability and current choices.
  Desktop Phase 3 provides the catalog and personal action endpoints.
- Mobile currently requires connector API `0.14.0`. The app shows the
  update-required state for older Desktop API versions.

### Mobile interaction

- The API client fetches the typed catalog and sends pick, ban, ban-none,
  lock-in, and spell commands. Pick intent uses the pick command during
  planning. Champion and spell selection send typed JSON bodies. Success is
  HTTP `204`, and the Mobile API client treats non-2xx responses as errors.
- The feature-local Cubit loads the catalog when the champion-select view
  mounts and owns its loading state, per-action request statuses, and
  completion events. `GameCubit` owns the live session stream. The
  champion-select view keeps the phase, countdown, position, champion, and
  spells visible while the session is active.
- The champion card opens a searchable picker when the session allows pick
  intent, picking, or banning. The picker groups favorites first, then the
  remaining champions, with alphabetical order in each group. It disables the
  unavailable champion IDs from the live session. A ban picker includes a
  No Champion row when results are shown.
- Both spell rows become actionable when the shared spell-change capability
  is present. Their pickers show the alphabetized catalog and mark the current
  spell. The picker includes the other slot's spell. Desktop rejects an
  attempt to assign that same spell to both slots.
- Show Lock In when the session allows it and a champion name is present.
  Tapping invokes the cubit directly. The cubit starts the request once the
  catalog is loaded, and the button is disabled during submission. Lock-in
  failures have no dedicated inline message. A No Champion selection has no
  champion name, so Mobile currently offers no Lock In button for it.
- A pending picker command disables input in that picker. Successful
  selection closes the picker through a completion event. Failed commands
  keep the picker open with inline feedback and allow another selection.
  A failed catalog load shows a Retry action.
- The parent view removes controls when the session's availability changes
  and disposes the Cubit when champion select ends. An already-open picker
  has no explicit dismissal on availability changes. See the
  [Mobile resilience plan](#phase-4--end-to-end-resilience) for
  remaining request and picker lifecycle work.
- The phase labels, picker guidance, and recovery copy come from Mobile's
  English Slang source and generated accessors.

### Verification

- In a solo draft, verify pick intent, picks, bans, spell changes, and direct
  lock-in. Confirm the displayed choices change with the next live session,
  after the corresponding request succeeds.
- Check search, favorites-first ordering, disabled champion rows, the
  No Champion command, and duplicate-spell rejection.
- Check picker progress and recovery for both command and catalog failures.
  Verify the controls change when a turn expires and the game view changes
  when champion select ends.

### Constraints

- The controls affect the local player's pick intent, pick, ban, lock-in, and
  individual spell choices.
- Team control, trades, ARAM rerolls, skins, position changes, party
  management, and loaded-match controls remain outside this phase.

## Phase 4 — End-to-End Resilience

### Summary

Use live Desktop snapshots to replace stale Mobile game state during
matchmaking. Game-level actions are guarded by a session revision. Champion
select consumes the live snapshots and has separate per-action progress, with
remaining gaps in request reconciliation and modal handling.

### Prerequisites and compatibility

- Mobile phases 1–3 provide the session consumer, game commands, and the
  feature-local champion-select Cubit. Desktop publishes typed availability
  and returns HTTP success or failure for command requests.
- Mobile currently requires connector API `0.14.0`. The resilience behavior
  uses the existing routes and shared session models.

### Mobile state and recovery

- `GameCubit` replaces the displayed game state on each session event.
  It increments a revision and clears game-level loading and retry feedback.
  Lobby, matchmaking, and ready-check requests capture the current revision.
  Success or failure affects local request state only while that revision
  remains current.
- The Mobile API client treats any non-2xx command response as a typed
  request error, maps transport failures, and uses no success body to update
  the session snapshot.
- The game component disables lobby actions, cancel-search, and Accept Game
  while a game-level command is pending. When a current request fails,
  the game surface shows localized inline recovery and offers Retry when the
  current game state permits it. A newer session clears that retry callback.
- The connection component owns Desktop-link loss and reconnection. A
  disconnected state replaces game controls with the connection surface.
  `GameCubit` also schedules a retry when its session stream closes or reports
  an expected API failure.
- The champion-select cubit receives updated snapshots and keeps request
  statuses per action. Its action handlers ignore completions after the cubit
  closes. The parent view derives control visibility from the latest
  champion-select availability.

### Outstanding resilience work

- Apply the pending state to Decline Game. The button remains enabled during
  an in-flight ready-check command, and the Cubit has no shared in-flight guard.
- Add snapshot reconciliation to champion-select requests. A catalog
  load currently captures the starting snapshot and can replace a newer
  snapshot when it completes. Late actions can still emit completion or
  failure feedback after a newer snapshot changes availability.
- Reconcile open picker routes with lost availability and the end of champion
  select. The parent view updates its controls and disposes its cubit at phase
  end, while an already-open picker has no explicit phase-change dismissal.
- Decide whether champion-select commands need one shared in-flight guard.
  The current guard prevents duplicate submissions for the same action.

### Verification

- Run the solo draft loop through lobby, matchmaking, ready check, champion
  select, game, and post-game. Confirm that each game view follows the
  newest Desktop session event.
- Deliver delayed lobby and ready-check responses after a new session update.
  Verify that late success and failure leave the new view intact and that a
  current failure still offers inline Retry.
- Disconnect Desktop during queueing or champion select, then reconnect
  and confirm Mobile shows the connection surface until a fresh session loads.
- Reproduce a catalog response crossing a session update and leave champion
  select with a picker open to check the outstanding resilience cases.

### Constraints

This phase concerns Mobile resilience. Desktop behavior, party management,
team controls, trades, ARAM mechanics, and loaded-match controls are outside
its scope.

## Phase 5 — Website Update for the Full Draft Loop

### Summary

Refresh the Jaspr/Tailwind product site to present Remote Rift as a local,
solo draft-queue companion: role preferences through champion-select actions,
then the loaded match. Preserve the current light editorial visual system and
screenshot-first layout.

### Current implementation

This phase is pending. The site currently presents queue and lobby management
through the ready check. Its hero shows a single ready-check screenshot, its
features list matchmaking actions and queue groups, and its status section
focuses on connection recovery. The Mobile download description also ends at
the ready check. The draft-flow copy, scope callout, and screenshot sequence
below remain to be delivered.

### Key changes

- Review the design system and web layout with `ui-ux-pro-max` before updating
  the product page.
- Rework hero and feature copy around the complete flow: choose a supported
  draft queue and roles, create/search/cancel a lobby, accept a ready check,
  then select or ban when assigned, set spells, and lock in.
- Replace broad queue claims with precise “solo draft queue” language. Add a
  compact scope-limits callout stating that party management, champion trades,
  and ARAM-specific controls are not included.
- Update the connection/setup sequence and Mobile download description to
  explain the end-to-end flow while retaining Desktop as the local League
  Client connector.
- Explain that live League Client state drives the main action controls and that
  in-game and post-game status is informational. Check the remaining picker
  lifecycle work in [Mobile Phase 4](#phase-4--end-to-end-resilience)
  before describing how open pickers handle an expired action.
- Keep the current component structure, typography, palette, responsive
  breakpoints, keyboard focus behavior, and restrained motion. Do not add a
  new design system or unrelated navigation.
- Capture three native Mobile screens for role and lobby setup, ready check,
  and actionable personal champion select. Use the champion-select capture in
  the hero and show the others as a concise flow sequence.

### Interfaces and content

- Extend the website’s content data to represent grouped released capabilities
  and deferred capabilities, replacing the current flat matchmaking/queue lists
  where needed.
- Add only the component/layout support needed to render the screenshot
  sequence and scope-limits callout; no product API changes.

### Verification

- Manually review the published page at narrow mobile, tablet, and desktop
  widths for readable copy, uncropped screenshots, stable section hierarchy,
  visible focus styles, and accurate image alt text.
- Confirm every claim maps to the released Mobile/Desktop flow and that
  deferred features are named plainly.
- Verify the screenshot files are native captures of the completed flow and
  their displayed aspect ratios remain intact.

### Assumptions

- Role preferences and personal champion-select controls exist in the app.
  Verify the advertised flow in the Mobile and Desktop versions the site will
  point readers to.
- The site continues to target the existing local-network Desktop + Mobile
  setup; no remote/cloud control claims are added.
- No automated tests are added or run under the repository working agreement.
