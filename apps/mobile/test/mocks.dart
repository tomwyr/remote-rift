import 'package:mocktail/mocktail.dart';
import 'package:remote_rift_mobile/data/api_client.dart';
import 'package:remote_rift_mobile/data/app_config.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

class MockAppConfig extends Mock implements AppConfig;

class MockRemoteRiftApiClient extends Mock implements RemoteRiftApiClient;

class MockServiceRegistry extends Mock implements ServiceRegistry;
