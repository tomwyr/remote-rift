# Remote Rift Simulator PRD

## Problem

Developers and testers need a repeatable way to exercise Remote Rift's League
Client integration. A live match depends on Riot services and other players,
and makes it difficult to reproduce specific outcomes such as a declined ready
check or an expired champion pick.

## Proposed solution

Provide a standalone simulator that Remote Rift Desktop can use as a League
Client through its existing connection settings. Testers can drive and observe
a simulated session locally, including scenarios that are difficult to arrange
in a live match.

## Product requirements

1. Run locally on macOS and Windows. Let testers connect Desktop to the
   simulator and switch back to the real client through the existing settings.
2. Support the League Client interactions Remote Rift needs for Normal Draft
   Pick and ARAM, from lobby creation through matchmaking, champion select,
   and return to the lobby after a simulated game.
3. Let testers reproduce common variations, including ready-check outcomes,
   champion-select timeouts, and temporary client unavailability.
4. Show the current session and give testers controls to advance or reset it
   so they can repeat a scenario without waiting through the full flow.
5. Keep simulation local and preserve the real client's files and the existing
   behavior of Desktop, Mobile, and their Connector.

## Scope

The simulator covers the League Client integration. Live gameplay, Riot
services, and a separate development Connector for Mobile testing are outside
this feature.

## Related documents

- [Remote Rift Simulator implementation plan](../plans/league-client-simulator.md)
