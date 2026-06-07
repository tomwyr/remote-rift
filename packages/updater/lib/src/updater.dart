import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'github_releases.dart';
import 'update_runner.dart';

abstract interface class ApplicationUpdater {
  Future<void> installUpdate({required AvailableUpdate update});
  Future<AvailableUpdate?> checkUpdateAvailable();
}

class DesktopUpdater implements ApplicationUpdater {
  DesktopUpdater({required this.releases, required this.updateRunner});

  final GitHubReleases releases;
  final UpdateRunner updateRunner;

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
    final downloadPath = await releases.downloadRelease(
      releaseTag: update.releaseTag,
    );
    if (downloadPath == null) {
      throw ApplicationUpdaterError.updateDownloadFailed;
    }

    try {
      await updateRunner.startProcess(archivePath: downloadPath);
      exit(0);
    } catch (_) {
      throw ApplicationUpdaterError.installerStartupFailed;
    }
  }

  Future<AvailableUpdate> _getLatestUpdate() async {
    try {
      final latestTag = await releases.getLatestReleaseTag();
      if (latestTag == null) {
        throw ApplicationUpdaterError.latestVersionUnavailable;
      }
      final versionTag = latestTag.substring(releases.tagPrefix.length);
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

class AvailableUpdate {
  AvailableUpdate({required this.version, required this.releaseTag});

  final Version version;
  final String releaseTag;
}

enum ApplicationUpdaterError implements Exception {
  latestVersionUnavailable,
  currentVersionUnavailable,
  updateDownloadFailed,
  installerStartupFailed,
}
