# Unify Desktop settings storage

## Goal

Store the Desktop app's lockfile, MCP, and diagnostic logging preferences in
one typed settings document. Core consumers can provide their own lockfile
configuration, with an in-memory default.

## Implementation

1. Use `LcuConnectionConfiguration` for loading, saving, and clearing a custom
   lockfile path. `LcuConnection()` uses the in-memory implementation by default.
2. Use one Desktop-lifetime `AppSettingsStore` backed by `settings.json` in
   `%LOCALAPPDATA%/Remote Rift` on Windows or `~/Library/Application Support/Remote Rift`
   on macOS. The document stores the optional lockfile path, whether MCP was
   previously enabled, whether it starts on launch, and diagnostic capture
   preference. A missing file yields defaults without creating the file.
3. Use the shared `JsonFileStore` cache and read–modify–write path to preserve
   unrelated values when a setting is updated.
4. Inject the store into the Desktop-owned LCU connection and reuse that connection
   for Settings, Desktop connection status, and MCP. The Mobile-facing API still
   uses separately constructed default connectors.
5. Keep the JSON shape defined by `AppSettings` and its generated serializer.
   The document has no schema version and the store has no import for legacy
   `lcu-connection.json` or `mcp.json` files.

## Upgrade behavior

A settings file missing `diagnosticLoggingEnabled` fails to decode today.
Defaulting that field to false while preserving previously saved preferences is
outstanding. See the [logging plan](diagnostic-logging.md).

## Verification

1. Check fresh defaults, persistence after relaunch, and updates that change
   a single preference without overwriting the others.
2. Check overlapping lockfile and MCP changes against the final stored values.
3. Load a settings file written before diagnostic logging and confirm the known
   upgrade gap separately from the normal save and load path.
