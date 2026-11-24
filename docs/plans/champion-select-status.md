# Champion Select Status

## Purpose

Show the signed-in player's current Champion Select status on Mobile while the
League Client is in `GameflowPhase.champSelect`. Mobile displays the phase,
remaining time, choice, role, and summoner spells. The personal actions that
share this screen are covered by [Mobile Phase 3](full-matchmaking-loop-mobile.md#phase-3--personal-champion-select).

## Mobile experience

- Show a dedicated Champion Select view during that phase and the generic
  in-game status during gameplay and post-game.
- Present the phase and countdown first, followed by the local champion
  choice, assigned position, and both spell choices.
- Present the preferred champion during planning and the local pick or ban
  choice during the corresponding turn. Use explicit placeholders for absent
  choices and show resolved selections by name.
- Show personal controls based on the current action availability. Updated
  choices come from live session data.

## Shared session contract

Desktop reads `GET /lol-champ-select/v1/session` during Champion Select and maps
it into the existing `/session/watch` WebSocket stream. It uses
`localPlayerCellId` and `myTeam` to identify the signed-in player.

The published state carries a normalized timer phase and remaining time, the
local player's display-ready champion and spell choices, assigned position,
turn, and current action availability. Unavailable champion catalog IDs let
Mobile disable the corresponding picker entries. Champion and spell command
IDs come from the separate catalog. See the
[Desktop/API implementation](champion-select-status-desktop-api.md).

## Desktop/API requirements

- Keep Champion Select separate from the generic in-game state and read the
  Champion Select session only in that gameflow phase.
- Resolve names from League Client metadata through the connector cache.
  Missing optional choices remain unavailable independently.
- Publish session changes on the one-second poll. An unrecognized or
  incomplete timer yields an unknown session state. The connector skips direct
  LCU connection or client errors. A failure wrapped by the parallel metadata
  lookup can end the session stream.
- Follow the next live gameflow phase when Champion Select ends.

## Mobile requirements

- Render the status through the existing game-state flow and keep
  Champion Select state in its feature-local cubit.
- Format the countdown and localize phase, position, and placeholder labels
  through the existing Mobile localization source.
- Keep sections readable within the scrolling status layout and update the
  displayed choices from the session feed.

## Acceptance scenarios

- The player sees the phase and countdown on entering Champion Select.
- An empty champion choice remains explicit while available role and spell
  details are visible.
- If a role or spell choice is missing, its placeholder leaves the phase and
  other resolved choices readable.
- Planning shows the current pick intent. Later turns show the local pick or
  ban choice reported by Desktop.
- Leaving Champion Select switches to the next live game state, including the
  generic in-game view when gameplay begins.
- Mobile consumes the connector's session stream and uses its API for personal
  commands. Desktop remains responsible for League Client access.

## Exclusions

The status surface does not present a team roster, champion trades, rerolls,
swap controls, or champion portraits.
