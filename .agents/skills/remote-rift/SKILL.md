---
name: remote-rift
description: "Control League of Legends matchmaking through the Remote Rift MCP server, including lobbies, ready checks, and champion select. Use when Remote Rift tools are available."
---

# Remote Rift MCP

Use the currently exposed `mcp__remote_rift__` tools. Do not assume a tool exists; inspect the
available Remote Rift tools when the intended action is unclear.

## Read game state

- Call `get_session` before choosing a state-dependent action.
- `get_server_status` confirms MCP server lifecycle only; use `get_connection_status` to check
  League Client availability.
- Treat the response as Remote Rift's normalized state, not the League Client's raw gameflow phase.
- A ready check is `state.value == "found"`; respond only while `state.state == "pending"`.
  Do not look for a `readyCheck` string.

## Matchmaking

1. List queues while in pre-game, then create the selected lobby.
2. Start matchmaking only from an idle lobby.
3. When a pending ready check is observed, immediately call `accept_ready_check` or
   `decline_ready_check` as requested. The response window is 10 seconds.

During time-sensitive flows, such as waiting for a ready check, poll `get_session` every
500 milliseconds. Do not use high-frequency polling for routine connection checks.

Use the tool's state errors as the source of truth when an action is unavailable. Do not attempt
to compensate by performing an incompatible lobby or champion-select action.

## Champion select

Use the catalog tool only during champion select. Select or ban a champion, set spells, and lock
in only when their corresponding Remote Rift tools are available and the current normalized state
permits the action.
