# Configurable League Client lockfile location

## Goal

Let Remote Rift Desktop choose, persist, validate, and reset an optional League
Client lockfile path. Desktop connection status and MCP use the configured
location. The Mobile API still uses the platform default through its own
connectors.

## Approach

Desktop owns one `LcuConnection` backed by `AppSettingsStore`. The connection's
`LcuLockfilePath` lazily loads the optional override, shares the initial load
with concurrent callers, and falls back to the platform's League lockfile
path. Desktop status, MCP, and the Settings cubit receive that same connection
from `Dependencies`.

Settings contains a dedicated lockfile card alongside MCP and Diagnostics.
The widget opens the native file chooser. The cubit validates the selected
file through `LcuConnection`, then requests persistence and surfaces errors
inline. Saving or resetting clears the connection's cached credentials after
persistence succeeds.

## Data flow

```text
Desktop connection status or MCP operation
  Dependencies -> shared Desktop LcuConnection
  -> LcuLockfilePath -> AppSettingsStore -> settings.json
  -> saved override or platform default -> parsed, cached credentials

Settings choose or reset
  SettingsPage -> SettingsCubit -> LcuConnection
  -> validate the chosen file -> persist the override or clear it
  -> clear the connection's cached credentials

Mobile API operation
  ConnectorRoutes -> RemoteRiftConnector()
  -> separate LcuConnection with in-memory configuration -> platform default
```

The configured path stays local to Desktop settings and is absent from the
Mobile API payloads. Saving or resetting the path does not cancel requests.

## File changes

| File | Responsibility |
| --- | --- |
| `packages/core/lib/src/lcu/lcu_connection.dart` | Resolve and cache the active path and parsed credentials. Validate candidate paths and invalidate cached credentials after successful saves and resets. |
| `packages/core/lib/src/lcu/lcu_connection_store.dart` | Define `LcuConnectionConfiguration` and supply the in-memory default used by standalone connections. |
| `packages/core/lib/src/connector.dart` | Accept an injected `LcuConnection` and create a default connection when one is omitted. |
| `apps/desktop/lib/services/app_settings_store.dart` | Implement the configuration contract with the nullable path stored in the Desktop `settings.json`. |
| `apps/desktop/lib/dependencies.dart` | Inject the configured connection into Desktop connection status, MCP, and Settings. |
| `apps/desktop/pubspec.yaml` and workspace lockfile | Declare and resolve `file_selector` for the native chooser. |
| `apps/desktop/lib/ui/connection/connection_page.dart` | Open the Settings route from the connection-page header. |
| `apps/desktop/lib/ui/settings/settings_page.dart` | Provide the local cubit, render the lockfile card, and own native file selection. |
| `apps/desktop/lib/ui/settings/settings_cubit.dart` and `settings_state.dart` | Load the current path, validate and save a selection, reset, and expose saving and failure state. |
| `apps/desktop/lib/i18n/en.i18n.yaml` and generated Slang output | Define the location labels, chooser actions, reset action, and inline error messages. |

## Implementation steps

### Task 1 — Configure the Desktop-owned connection

1. Give `LcuLockfilePath` a typed configuration store. Use its cached custom
   path once loaded and return the platform default when the override is
   null.
2. Use `AppSettingsStore` behind the Desktop connection. Persist the custom
   path with the other Desktop preferences in one `settings.json` document.
3. Use the injected connection for Desktop status and MCP connector
   construction. Core callers without an injected store default to in-memory
   configuration.
4. Validate candidate file contents with the existing loader and parser.
   Treat selecting the exact default path as a reset. Clear cached
   credentials after either persisted operation completes.

### Task 2 — Expose the Settings card

1. Open the existing Desktop Settings route with a local `SettingsCubit`.
2. Show Default location or Custom location, along with the full path when
   custom. Offer Choose or Change and show Reset only in custom mode.
3. Open the native file chooser without restricting file extensions. Pass
   its selected path to the cubit.
4. Disable actions while saving. Preserve the previously loaded path when
   validation or persistence fails and show the corresponding inline error.

### Task 3 — Preserve runtime behavior and localization

1. Keep runtime missing and invalid lockfile failures in the existing
   connection error flow. Settings selection errors have separate copy.
2. Maintain lockfile text in Desktop's Slang source and use the generated
   accessors at the widget boundary.

## UX and migration behavior

| State | Settings page | Desktop status and MCP |
| --- | --- | --- |
| No settings file or no override | Shows Default location and Choose. | Read the platform default. |
| Custom path saved | Shows Custom location, full path, Change, and Reset. | Subsequent credential loads use the custom path. |
| Chooser cancelled | Leaves the current mode and path visible. | Keeps the current path. |
| Invalid selection or failed save | Shows inline feedback and preserves the prior path in state. | Preserves the existing configured location. |
| Reset or select the exact default path | Shows Default location and clears the override. | Subsequent credential loads use the platform default. |

Desktop reads the path from the unified settings document. Importing a separate
legacy lockfile configuration file is outside the current store behavior. See
[Unified Desktop settings storage](unify-desktop-settings-storage.md) for the
current format and its upgrade limits.

## Acceptance criteria

1. With no override, Windows uses `C:\Riot Games\League of Legends\lockfile`
   and macOS uses `/Applications/League of Legends.app/Contents/LoL/lockfile`.
2. A valid custom path persists across relaunch. Reset clears it and restores the
   default.
3. Desktop connection status and MCP use the path through the injected
   connection. A successful change clears cached credentials.
4. Native chooser selection validates before persistence and displays inline
   failures while preserving the current selection.
5. Missing runtime lockfiles still surface through the connection flow. The
   path is absent from Mobile and API wire models.

## Verification steps

1. Open Desktop Settings and check default, custom, invalid, cancelled, failed
   save, reset, and relaunch behavior.
2. Check that Desktop connection status and MCP use the saved path after save
   and reset.
3. With League installed only at a custom path, check Desktop status and
   compare it with Mobile's API status. The API currently still resolves the
   platform-default path.
4. Confirm the connection flow handles a missing or malformed active lockfile
   without replacing the saved setting.

## Risks and decisions

- League lockfiles have no extension. Validate the contents of the chosen file.
- Desktop settings storage uses the Remote Rift directory under
  `%LOCALAPPDATA%` on Windows or `~/Library/Application Support` on macOS.
  Storage errors are surfaced as `AppSettingsError.unavailable`.
- API route construction still bypasses the Desktop-owned connection. Applying
  the saved path to Mobile's connector requests remains an implementation gap.
