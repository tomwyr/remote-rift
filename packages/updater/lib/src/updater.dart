import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'github_releases.dart';
import 'update_runner.dart';

abstract interface class ApplicationUpdater {
  Future<void> installUpdate({required AvailableUpdate update});
  Future<AvailableUpdate?> checkUpdateAvailable();
}

class DesktopUpdater({
  required final GitHubReleases _releases,
  required final UpdateRunner _updateRunner,
}) implements ApplicationUpdater {
  @override
  Future<AvailableUpdate?> checkUpdateAvailable() async {
    final latest = await _getLatestUpdate();
    final current = await _getCurrentVersion();
    if (latest.version.isGreaterThan(current)) {
      return latest;
    }
    return null;
  }

  @override
  Future<void> installUpdate({required AvailableUpdate update}) async {
    final downloadPath = await _releases.downloadRelease(
      releaseTag: update.releaseTag,
    );
    if (downloadPath == null) {
      throw ApplicationUpdaterError.updateDownloadFailed;
    }

    try {
      await _updateRunner.startProcess(archivePath: downloadPath);
      exit(0);
    } catch (_) {
      throw ApplicationUpdaterError.installerStartupFailed;
    }
  }

  Future<AvailableUpdate> _getLatestUpdate() async {
    try {
      final latestTag = await _releases.getLatestReleaseTag();
      if (latestTag == null) {
        throw ApplicationUpdaterError.latestVersionUnavailable;
      }
      final versionTag = _releases.versionFromTag(latestTag);
      return AvailableUpdate(
        version: .parse(versionTag),
        releaseTag: latestTag,
      );
    } catch (_) {
      throw ApplicationUpdaterError.latestVersionUnavailable;
    }
  }

  Future<Version> _getCurrentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return .parse(info.version);
    } catch (_) {
      throw ApplicationUpdaterError.currentVersionUnavailable;
    }
  }
}

class AvailableUpdate({
  required final Version version,
  required final String releaseTag,
}) {}

enum ApplicationUpdaterError implements Exception {
  latestVersionUnavailable,
  currentVersionUnavailable,
  updateDownloadFailed,
  installerStartupFailed,
}
