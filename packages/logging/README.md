# Remote Rift Logging

Shared application logging for Remote Rift.

## Overview

Remote Rift Logging records application events in a common format. Timestamps let maintainers compare timelines across log exports when investigating an issue.

Callers define the events and choose which details are safe to record. The package stores records locally and prepares snapshots for sharing or export.

## Capture and retention

Capture is off by default. The logger keeps up to seven days and 2 MiB of records by default, removing older records first. Pass a `LogConfig` to set custom retention limits.

```dart
import 'package:remote_rift_logging/remote_rift_logging.dart';

final logger = await AppLogger.open(
  storageDirectory: logDirectory,
  app: appId,
  appVersion: installedVersion,
  sessionId: launchSessionId,
  config: LogConfig(maxAge: const Duration(days: 3), maxBytes: 512 * 1024),
);
```

## Recording an event

Apply the saved capture preference before recording events.

```dart
logger.setCaptureEnabled(savedOptIn);
await logger.record('session_started', .info);
```

## Snapshots

A snapshot contains all retained records. Callers can prepare a snapshot or clear retained logs while capture is off.
