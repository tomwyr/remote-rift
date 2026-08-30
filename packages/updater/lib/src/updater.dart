import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'file_utils.dart';
import 'github/github_releases.dart';
import 'models.dart';
import 'update_diagnostics.dart';
import 'update_downloader.dart';
import 'update_release_catalog.dart';
import 'update_runner.dart';

abstract interface class ApplicationUpdater {
  Future<void> acknowledgeHealthyStart();
  Future<UpdateRelease?> checkUpdateAvailable();
  Future<void> installUpdate({required UpdateRelease update});
}

class DesktopUpdater({
  required final UpdateReleaseCatalog _releaseCatalog,
  required final UpdateDownloader _updateDownloader,
  required final UpdateRunner _updateRunner,
  final UpdateDiagnostics _diagnostics = const UpdateDiagnostics(),
}) implements ApplicationUpdater {
  @override
  Future<void> acknowledgeHealthyStart() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    await _updateRunner.acknowledgeHealthyStart(version: version);
  }

  @override
  Future<UpdateRelease?> checkUpdateAvailable() async {
    try {
      final latest = await _releaseCatalog.getLatest();
      if (latest == null) return null;
      final current = await _getCurrentVersion();
      if (latest.version.isGreaterThan(current)) {
        return latest;
      }
      return null;
    } on GitHubReleaseError catch (error) {
      await _diagnostics.record(event: 'update_check_failed', detail: error.name);
      throw ApplicationUpdaterError.latestVersionUnavailable;
    } on ApplicationUpdaterError catch (error) {
      await _diagnostics.record(event: 'update_check_failed', detail: error.name);
      rethrow;
    }
  }

  @override
  Future<void> installUpdate({required UpdateRelease update}) async {
    String? downloadPath;
    try {
      downloadPath = await _updateDownloader.download(artifact: update.artifact);
      final expectedVersion = update.version.stringValue;
      await _updateRunner.startProcess(
        archivePath: downloadPath,
        expectedVersion: expectedVersion,
      );
      exit(0);
    } on UpdateDownloadError catch (error) {
      await _diagnostics.record(event: 'download_failed', detail: error.name);
      throw switch (error) {
        .archiveTooLarge => ApplicationUpdaterError.archiveTooLarge,
        .invalidResponse => ApplicationUpdaterError.updateDownloadInvalid,
        _ => ApplicationUpdaterError.updateDownloadFailed,
      };
    } catch (error) {
      if (error case FileSystemException() || ProcessException() || UpdateFileError()) {
        await _failInstallerStartup(downloadPath, error);
      }
      rethrow;
    }
  }

  Future<Version> _getCurrentVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return .parse(packageInfo.version);
    } on VersionError {
      throw ApplicationUpdaterError.currentVersionUnavailable;
    }
  }

  Future<Never> _failInstallerStartup(String? downloadPath, Object error) async {
    if (downloadPath case var path?) {
      await _updateRunner.cleanupArchive(path);
    }
    final detail = switch (error) {
      UpdateFileError() => error.name,
      _ => null,
    };
    await _diagnostics.record(event: 'installer_start_failed', detail: detail);
    throw ApplicationUpdaterError.installerStartupFailed;
  }
}

enum ApplicationUpdaterError implements Exception {
  latestVersionUnavailable,
  currentVersionUnavailable,
  updateDownloadFailed,
  updateDownloadInvalid,
  archiveTooLarge,
  installerStartupFailed,
}
