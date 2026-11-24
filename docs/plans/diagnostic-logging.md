# Diagnostic logging in three phases

Mobile and Desktop use the same local logger and can export snapshots for comparing a connection
failure across both devices. Fresh installs start with capture off. The opt-in is stored by each
app, and logs stay on the device until the user shares or exports them.

## Phase 1 — Shared logging

- Add `packages/logging` to the Dart workspace. Expose operations to enable or disable capture,
  record events, prepare a snapshot, clear retained records, and observe storage status. Each app
  supplies its standard app support directory, app identifier, installed version, and per-launch
  session identifier.
- Define one versioned UTF-8 NDJSON record format with UTC timestamps, app identifiers and
  versions, per-launch session identifiers, severity, an event name, and optional details. Each app
  defines its stable event names and allowlisted detail properties. Both apps use the same
  operation names for shared routes. Failure categories reflect each app's observation. A rejected
  connector command can appear as `http_error` on Mobile and `operation_rejected` on Desktop.
  Use timestamps to compare timelines.
- Store records in `log.ndjson`. Serialize asynchronous writes, pruning, snapshots, and clearing.
  Default to **7 days and 2 MiB per installation**, with both limits configurable when opening the
  logger. Drop the oldest records first. Prune on startup, during capture, and before taking a
  snapshot, including when capture is off. Report storage failures in Diagnostics while app
  operations continue.

## Phase 2 — Mobile

### 2.1 — Logging package integration and event logging

- Integrate the shared logger and record app startup when capture is enabled.
- Add Mobile-owned logger extensions for discovery, service probes, connection attempts, live
  status stream interruption and recovery, and game command completion. Record transitions and
  outcomes with classified failures. Skip repeated status snapshots.

### 2.2 — Logging settings

- Open Settings from the Home app bar and show a Diagnostics card with its own Cubit. Persist the
  opt-in in a typed local settings store. Default to off and load the preference before feature
  startup.
- Show storage status and provide **Clear logs** independently of capture. Localize the toggle,
  privacy copy, actions, and status messages.

### 2.3 — Log sharing

- Add **Share logs** through the Android and iOS system share sheet. Prepare a temporary snapshot
  of retained logs, including when capture is off. Distinguish empty logs, cancellation, and
  retryable preparation or sharing failures. Clean up the temporary snapshot when the share sheet
  finishes. Keep retained logs available after each outcome.

## Phase 3 — Desktop

### 3.1 — Logging package integration and event logging

- Integrate the shared logger and record app startup when capture is enabled.
- Add Desktop-owned logger extensions for League client connection attempts, status changes,
  interruptions, attachment, and detachment, and for connector service start and stop. Skip
  repeated status snapshots.
- Give the connector service an optional typed failure observer for HTTP requests and WebSocket
  upgrades. Record the registered operation name, HTTP status, and a safe failure category. Use
  the same operation names as Mobile and preserve connector behavior.

### 3.2 — Logging settings

- Add a Diagnostics card to the existing Settings page with its own Cubit.
  Persist the opt-in in `AppSettingsStore`. Default to off and load the preference before connector
  startup.
- Show storage status and provide **Clear logs** independently of capture. Localize the toggle,
  privacy copy, actions, and status messages.
- Fresh settings default to off. A saved `settings.json` without `diagnosticLoggingEnabled`
  currently fails to decode. The service leaves capture off, and settings reads or updates can
  report the document as unavailable. Compatibility with those files is outstanding. The expected
  upgrade behavior is to default the missing preference to off and preserve the other values.

### 3.3 — Log export

- Add **Export logs** using the existing native file picker on macOS and Windows. Save the prepared
  snapshot to the selected destination. Distinguish empty logs, cancellation, and retryable
  preparation or save failures. Clean up the temporary snapshot when export finishes or is
  abandoned. Keep retained logs available after each outcome.

## Acceptance checks

- Verify Mobile status interruption and recovery and Desktop League client attachment, detachment,
  and connector start and stop. Confirm repeated snapshots produce no additional status records.
  Trigger a failed connector request and confirm Desktop records the registered operation, HTTP
  status, and a safe failure category.
- Confirm capture defaults to off on fresh installs, survives restart after opt-in, and records
  startup. Clear logs during capture and confirm that later events can still be recorded. Confirm
  a storage failure appears in Settings while connection and matchmaking continue to work.
- After upgrade compatibility is implemented, load a Desktop settings document saved before the
  logging preference existed. Confirm capture starts off and existing values remain readable and
  survive a subsequent save.
- Confirm empty logs, cancellation, and retryable failures have distinct outcomes in both apps.
  Verify sharing and export include all retained records after restart or after capture is
  disabled, and cancellation and failures preserve those records. Confirm retention limits still
  apply after restart.
- Reproduce a connection failure with both apps opted in.
  Compare the snapshots for the shared schema, installed versions, distinct sessions, UTC
  timestamps, and allowlisted details.
