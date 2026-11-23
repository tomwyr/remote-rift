# Remote Rift Diagnostic Logging PRD

## Purpose

When Remote Rift behaves unexpectedly in a production build, users can turn on diagnostic logging, reproduce the issue, and share a file with a maintainer. A maintainer should be able to identify the app version, reconstruct the sequence of relevant events, and see which operation failed. For problems between the mobile app and desktop connector, both exports should be readable together using the same event format.

## User experience

1. Open **Settings** and find the **Diagnostics** card. On mobile, tap the gear in the Home app bar. On desktop, scroll to the card. Enable **Diagnostic logging** on each affected device. Logging defaults to off for new installs and upgrades. The change takes effect once the app saves the preference and persists across restarts. The settings explain that logs stay on the device until the user exports or shares them.
2. Reproduce the issue. While enabled, the app writes new diagnostic events to private local files. For an issue spanning both apps, enable logging on both before reproducing it.
3. Select **Export logs** on desktop to save a file or **Share logs** on mobile to open the system share sheet. Each action uses a snapshot of all retained logs. Show when no logs are available and provide retryable errors for failures preparing, saving, or sharing the snapshot. Canceling the picker or share sheet leaves the original logs intact.
4. Turn off **Diagnostic logging** to stop capturing new events once the app saves the preference. Existing logs remain available for export or sharing within the retention limits. **Clear logs** removes the app’s retained logs independently of the logging setting.

## Diagnostic coverage

Both apps record startup while logging is enabled, relevant state transitions, and operation outcomes. Use a shared event vocabulary and failure categories where the apps observe equivalent behavior.

| App | Initial coverage |
| --- | --- |
| Desktop | League client attach and detach, connector service start and stop, and failures serving mobile operations |
| Mobile | Desktop discovery and connection attempts, live status stream interruption and recovery, and game command outcomes |

Record operation names and outcomes, with safe details such as an HTTP status code or a classified failure reason. Log changes and significant failures at operation boundaries so repeated polls or snapshots leave room for the events needed to investigate an issue.

## Shared package and app extensions

- Add a dedicated Dart workspace package at `packages/logging`. It owns the record format, levels, timestamps, local file storage, retention, and export snapshot creation. Both apps use the same logger and file format.
- Use UTF-8 newline-delimited JSON with a schema version, UTC timestamp, app identifier and version, session identifier, severity, stable event name, and optional structured details. Use UTC timestamps and shared connector operation names to compare the two timelines.
- Each app defines its event names and allowlisted detail properties in extensions on the shared logger. An extension method takes only the inputs needed to describe the event. For example, `logger.connectionFailed(error)` classifies the failure and builds the event inside the extension. Production call sites stay focused on the operation and its result.
- Each app owns settings persistence, logger initialization, private storage directory selection, and native export or sharing UI. The shared package exposes the same operations to both apps and stays independent of Flutter and app-specific types.

## Privacy and reliability

- Use allowlisted diagnostic fields. Omit credentials, authorization headers, raw request and response bodies, full URLs, IP addresses, user identifiers, and local paths. Map exceptions to safe categories before serialization. Exports use the same sanitized records as the local files.
- Bound local storage to **7 days and 2 MiB per app installation** by default. Remove the oldest records first as needed to meet either limit. Apply retention before export, including when capture is disabled.
- Keep file I/O asynchronous and isolate write failures from app operations. If capture cannot write to disk, surface a diagnostic status in Settings. Serialize file operations so concurrent events, pruning, export, and clearing leave the log and exported snapshots consistent.

## Acceptance criteria

1. Fresh and upgraded installs create no diagnostic records by default. After the app saves the opt-in, it records new events without a restart. The preference survives restart, and capture records only events observed while enabled.
2. With both apps opted in, a reproduced connection failure yields two exports that use the same schema and show the relevant operations, failure reasons, versions, and timestamps.
3. Desktop saves a readable snapshot and mobile opens the share sheet with one. Each app distinguishes empty logs, failures, and cancellation when the native picker or share sheet reports it. Source logs remain available after cancellation or failure.
4. Disabling capture stops new writes and leaves retained logs exportable. Clearing removes retained records, and age and size limits apply across restarts.
5. A storage failure leaves matchmaking and connection behavior working. Sensitive inputs are absent from both local logs and exports, and feature call sites use app-owned extensions to record events.
