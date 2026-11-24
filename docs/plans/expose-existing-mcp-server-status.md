# MCP server status

## Goal

Expose the existing `RemoteRiftMcpServer.isRunning` lifecycle state through a no-argument
`get_server_status` MCP health-check tool.

## Approach

Reuse the MCP server's existing `isRunning` getter rather than introducing a second liveness flag or
querying the League Client. Extend tool registration with the `RemoteRiftMcpServer` instance; the
tool returns that observed lifecycle value as structured JSON. This keeps MCP-server liveness distinct
from `get_connection_status`, which continues to report League Client availability.

## Implementation

1. The transport's server factory passes `RemoteRiftMcpServer` when configuring each
   `McpServer`.
2. Tool registration lists `get_server_status` before connector-dependent reads. It takes no
   arguments and returns structured content containing the Boolean `is_running` from
   `server.isRunning` at invocation time.
3. `get_connection_status` reads the connector and returns its serialized `RemoteRiftStatus`.
4. The [MCP package README](../../packages/mcp/README.md) lists both tools and their purposes.

## Verification

1. Run `dart analyze packages/mcp`.
2. Start the authenticated MCP server and invoke `get_server_status`; verify it returns
   `{ "is_running": true }`.
3. With the League Client unavailable, verify `get_server_status` still returns `is_running: true`
   while `get_connection_status` retains its existing behavior.
