import 'package:remote_rift_updater/remote_rift_updater.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remote_rift_connector/remote_rift_connector.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import 'common/platform.dart';
import 'services/api_service_runner.dart';
import 'services/noop_updater.dart';
import 'ui/connection/connection_cubit.dart';
import 'ui/service/service_cubit.dart';
import 'ui/update/update_cubit.dart';

class Dependencies {
  static ConnectionCubit connectionCubit(BuildContext context) =>
      ConnectionCubit(connector: RemoteRiftConnector());

  static ServiceCubit serviceCubit(BuildContext context) => ServiceCubit(
    runner: RemoteRiftApiServiceRunner(
      service: RemoteRiftApiService(),
      registry: .remoteRift(),
    ),
  );

  static UpdateCubit updateCubit(BuildContext context) {
    // Disable updates in debug mode to avoid hitting GitHub API rate limits.
    return UpdateCubit(updater: kDebugMode ? NoopUpdater() : desktupUpdater());
  }

  static ApplicationUpdater desktupUpdater() {
    return DesktopUpdater(
      releases: GitHubReleases(
        repoName: 'remote-rift',
        userName: 'tomwyr',
        tagPrefix: 'desktop-',
        resolveArtifactName: (releaseTag) {
          final platform = switch (targetPlatform) {
            .windows => 'windows',
            .macos => 'macos',
          };
          return 'RemoteRift-$releaseTag-$platform.zip';
        },
      ),
      updateRunner: UpdateRunner.platform(
        applicationLabel: 'remote-rift',
        macosBundleName: 'Remote Rift.app',
        windowsExecutableName: 'RemoteRift.exe',
      ),
    );
  }
}
