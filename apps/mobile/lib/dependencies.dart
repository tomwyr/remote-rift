import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import 'data/api_client.dart';
import 'data/app_config.dart';
import 'data/app_settings_store.dart';
import 'data/diagnostics_service.dart';
import 'data/mobile_logger.dart';
import 'ui/champion_select/champion_select_cubit.dart';
import 'ui/connection/connection_cubit.dart';
import 'ui/diagnostics/diagnostics_cubit.dart';
import 'ui/game/game_cubit.dart';

class Dependencies {
  static late final AppSettingsStore _settingsStore;
  static late final AppLogger _logger;

  static Future<void> initialize() async {
    _settingsStore = await AppSettingsStore.open();
    _logger = await MobileLogger.open();
  }

  static ConnectionCubit connectionCubit(BuildContext context) => ConnectionCubit(
    appConfig: _appConfig,
    apiClient: _apiClient,
    serviceRegistry: _serviceRegistry,
    settingsStore: _settingsStore,
    logger: _logger,
  );

  static GameCubit gameCubit(BuildContext context) => GameCubit(apiClient: _apiClient);

  static ChampionSelectCubit championSelectCubit(
    BuildContext context, {
    required ChampionSelect championSelect,
  }) => ChampionSelectCubit(
    apiClient: _apiClient,
    championSelect: championSelect,
  );

  static DiagnosticsCubit diagnosticsCubit(BuildContext context) {
    return DiagnosticsCubit(
      settingsStore: _settingsStore,
      service: DiagnosticsService(logger: _logger),
    );
  }

  static final _appConfig = AppConfig.defaults();
  static final _apiClient = RemoteRiftApiClient(
    client: HttpClient(),
    logger: _logger,
  );
  static final _serviceRegistry = ServiceRegistry.remoteRift();
}
