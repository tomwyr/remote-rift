import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:remote_rift_api/remote_rift_api.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';
import 'package:remote_rift_updater/remote_rift_updater.dart';

import 'common/platform.dart';
import 'services/api_service_runner.dart';
import 'services/app_settings_store.dart';
import 'services/desktop_logger.dart';
import 'services/diagnostic_events.dart';
import 'services/diagnostics_service.dart';
import 'services/mcp_secret_store.dart';
import 'services/noop_updater.dart';
import 'services/mcp_server_runner.dart';
import 'ui/connection/connection_cubit.dart';
import 'ui/diagnostics/diagnostics_cubit.dart';
import 'ui/service/service_cubit.dart';
import 'ui/mcp/mcp_integration_cubit.dart';
import 'ui/settings/settings_cubit.dart';
import 'ui/update/update_cubit.dart';

class Dependencies {
  static final _settingsStore = AppSettingsStore();
  static late final AppLogger _logger;
  static final _connection = LcuConnection(
    path: LcuLockfilePath(configuration: _settingsStore),
  );

  static Future<void> initialize() async {
    _logger = await DesktopLogger.open();
  }

  static ConnectionCubit connectionCubit(BuildContext context) => ConnectionCubit(
    connector: RemoteRiftConnector(lcuConnection: _connection),
    logger: _logger,
  );

  static ServiceCubit serviceCubit(BuildContext context) => ServiceCubit(
    settingsStore: _settingsStore,
    logger: _logger,
    runner: RemoteRiftApiServiceRunner(
      service: RemoteRiftApiService(
        createConnector: () => RemoteRiftConnector(lcuConnection: _connection),
        onFailure: _logger.connectorOperationFailed,
      ),
      registry: .remoteRift(),
      logger: _logger,
    ),
  );

  static UpdateCubit updateCubit(BuildContext context) {
    return UpdateCubit(updater: applicationUpdater());
  }

  static McpIntegrationCubit mcpIntegrationCubit(BuildContext context) {
    final secureStorage = FlutterSecureStorage(
      mOptions: MacOsOptions(usesDataProtectionKeychain: false),
    );

    return McpIntegrationCubit(
      settingsStore: _settingsStore,
      runner: McpServerRunner(
        connector: RemoteRiftConnector(lcuConnection: _connection),
        secretStore: McpSecretStore(secureStorage: secureStorage),
      ),
    );
  }

  static SettingsCubit settingsCubit(BuildContext context) {
    return SettingsCubit(connection: _connection);
  }

  static DiagnosticsCubit diagnosticsCubit(BuildContext context) {
    return DiagnosticsCubit(
      settingsStore: _settingsStore,
      service: DiagnosticsService(logger: _logger),
    );
  }

  static ApplicationUpdater applicationUpdater() {
    // Disable updates in debug mode to avoid hitting GitHub API rate limits.
    if (kDebugMode) return NoopUpdater();

    return DesktopUpdater(
      releaseCatalog: UpdateReleaseCatalog(
        releases: GitHubReleases(
          repoName: 'remote-rift',
          userName: 'tomwyr',
        ),
        tagPrefix: 'desktop-',
        resolveArtifactName: (releaseTag) {
          final platform = switch (targetPlatform) {
            .windows => 'windows',
            .macos => 'macos',
          };
          return 'RemoteRift-$releaseTag-$platform.zip';
        },
      ),
      updateDownloader: UpdateDownloader(),
      updateRunner: .platform(
        applicationLabel: 'remote-rift',
        macosBundleName: 'Remote Rift.app',
        windowsExecutableName: 'RemoteRift.exe',
      ),
    );
  }
}
