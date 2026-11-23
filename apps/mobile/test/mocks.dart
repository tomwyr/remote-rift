import 'package:mocktail/mocktail.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';
import 'package:remote_rift_mobile/data/api_client.dart';
import 'package:remote_rift_mobile/data/app_config.dart';
import 'package:remote_rift_mobile/data/app_settings_store.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

class MockAppConfig extends Mock implements AppConfig;

class MockAppSettingsStore extends Mock implements AppSettingsStore;

class MockRemoteRiftApiClient extends Mock implements RemoteRiftApiClient;

class MockServiceRegistry extends Mock implements ServiceRegistry;

class FakeAppLogger extends Fake implements AppLogger {
  @override
  void setCaptureEnabled(bool enabled) {}

  @override
  Future<void> record(String event, LogSeverity severity, {Map<String, Object?>? details}) async {}
}
