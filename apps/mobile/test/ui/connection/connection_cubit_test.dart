import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_mobile/ui/connection/connection_cubit.dart';
import 'package:remote_rift_mobile/ui/connection/connection_state.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import '../../mocks.dart';

void main() {
  late MockRemoteRiftApiClient apiClient;
  late MockServiceRegistry serviceRegistry;
  late MockAppConfig appConfig;
  late ConnectionCubit cubit;
  late StreamController<RemoteRiftStatusResponse> statusController;

  final timeLimit = Duration(seconds: 5);

  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  setUp(() {
    apiClient = MockRemoteRiftApiClient();
    serviceRegistry = MockServiceRegistry();
    appConfig = MockAppConfig();
    statusController = StreamController();
    cubit = ConnectionCubit(
      appConfig: appConfig,
      apiClient: apiClient,
      serviceRegistry: serviceRegistry,
    );
  });

  tearDown(() async {
    await cubit.close();
    await statusController.close();
  });

  test('reports incompatibility when service version is below the minimum', () async {
    when(() => appConfig.apiMinVersion).thenReturn('0.12.0');
    when(() => serviceRegistry.discover(timeLimit: timeLimit)).thenAnswer(
      (_) async => [ServiceAddress(host: '192.168.1.4', port: 8080)],
    );
    when(() => apiClient.getServiceInfo()).thenAnswer(
      (_) async => RemoteRiftApiServiceInfo(version: '0.11.0'),
    );

    cubit.initialize();
    await pumpEventQueue();

    expect(cubit.state, isA<ConnectedIncompatible>());
  });

  test('reports service not found when no endpoint is reachable', () async {
    when(() => appConfig.apiMinVersion).thenReturn('0.12.0');
    when(() => serviceRegistry.discover(timeLimit: timeLimit)).thenAnswer(
      (_) async => [
        ServiceAddress(host: '10.0.0.2', port: 8080),
        ServiceAddress(host: '192.168.1.4', port: 8080),
      ],
    );
    when(() => apiClient.getServiceInfo()).thenAnswer(
      (_) async => throw ClientException('Unreachable'),
    );

    cubit.initialize();
    await pumpEventQueue();

    expect(cubit.state, isA<ConnectionError>());
    final error = cubit.state as ConnectionError;
    expect(error.cause, ConnectionErrorCause.serviceNotFound);
    verify(() => apiClient.setApiAddress(null)).called(1);
  });

  test('uses the next endpoint when the first endpoint is unreachable', () async {
    when(() => appConfig.apiMinVersion).thenReturn('0.12.0');
    when(() => serviceRegistry.discover(timeLimit: timeLimit)).thenAnswer(
      (_) async => [
        ServiceAddress(host: '10.0.0.2', port: 8080),
        ServiceAddress(host: '192.168.1.4', port: 8080),
      ],
    );
    var serviceInfoRequests = 0;
    when(() => apiClient.getServiceInfo()).thenAnswer((_) async {
      if (serviceInfoRequests++ == 0) {
        throw ClientException('Unreachable');
      }
      return RemoteRiftApiServiceInfo(version: '0.12.0');
    });
    when(() => apiClient.getStatusStream(timeLimit: timeLimit * 2)).thenAnswer(
      (_) => statusController.stream,
    );

    cubit.initialize();
    await pumpEventQueue();
    statusController.add(RemoteRiftData(.ready));
    await pumpEventQueue();

    expect(cubit.state, isA<Connected>());
    verify(() => apiClient.setApiAddress('10.0.0.2:8080')).called(1);
    verify(() => apiClient.setApiAddress('192.168.1.4:8080')).called(1);
  });

  test('uses the next endpoint when the first response is malformed', () async {
    when(() => appConfig.apiMinVersion).thenReturn('0.12.0');
    when(() => serviceRegistry.discover(timeLimit: timeLimit)).thenAnswer(
      (_) async => [
        ServiceAddress(host: '10.0.0.2', port: 8080),
        ServiceAddress(host: '192.168.1.4', port: 8080),
      ],
    );
    var serviceInfoRequests = 0;
    when(() => apiClient.getServiceInfo()).thenAnswer((_) async {
      if (serviceInfoRequests++ == 0) {
        throw FormatException('Malformed response');
      }
      return RemoteRiftApiServiceInfo(version: '0.12.0');
    });
    when(() => apiClient.getStatusStream(timeLimit: timeLimit * 2)).thenAnswer(
      (_) => statusController.stream,
    );

    cubit.initialize();
    await pumpEventQueue();
    statusController.add(RemoteRiftData(.ready));
    await pumpEventQueue();

    expect(cubit.state, isA<Connected>());
    verify(() => apiClient.setApiAddress('10.0.0.2:8080')).called(1);
    verify(() => apiClient.setApiAddress('192.168.1.4:8080')).called(1);
  });
}
