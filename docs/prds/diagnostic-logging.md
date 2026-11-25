# Remote Rift Diagnostic Logging PRD

## Problem

When Remote Rift fails on a user's device, maintainers need to know what
happened before the failure and which operation failed. For issues involving
both Mobile and Desktop, each app sees only part of the sequence.

## Proposed solution

Offer opt-in diagnostic logging on Mobile and Desktop. Users can enable it,
reproduce the issue, and share their logs with a maintainer. The logs give
maintainers enough context to reconstruct the sequence across both apps.

## Product requirements

1. Keep capture off by default for fresh and upgraded installs. Let users
   enable or disable it without restarting, and remember their preference.
2. Capture relevant app, connection, and operation events. Give maintainers
   enough context to identify the app version, locate failures, and correlate
   events from Mobile and Desktop.
3. Keep logs on the device until users choose to export or share them. Exclude
   sensitive information from both retained logs and exports.
4. Let users export or share retained logs, including after capture is
   disabled, and clear them at any time. Make empty logs and retryable
   failures visible, and preserve retained logs when sharing is canceled or
   fails.
5. Limit local storage use and surface storage failures while Remote Rift's
   normal connection and matchmaking features continue to work.

## Related documents

- [Diagnostic logging implementation plan](../plans/diagnostic-logging.md)
