import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:remote_rift_mobile/data/api_client.dart';

void main() {
  late HttpClient webSocketClient;
  late Future<Response> Function(Request request) serviceInfoHandler;
  late RemoteRiftApiClient apiClient;

  setUp(() {
    webSocketClient = HttpClient();
    serviceInfoHandler = (_) async => throw UnimplementedError();
    apiClient = RemoteRiftApiClient.withClients(
      httpClient: MockClient((request) => serviceInfoHandler(request)),
      webSocketClient: webSocketClient,
    );
  });

  tearDown(() => webSocketClient.close(force: true));

  test('gets service information from the selected endpoint', () async {
    final requestedHosts = <String>[];
    serviceInfoHandler = (request) async {
      requestedHosts.add(request.url.host);
      return Response('{"version":"0.12.1"}', 200);
    };
    apiClient.setApiAddress('192.168.1.4:8080');

    final serviceInfo = await apiClient.getServiceInfo();

    expect(serviceInfo.version, '0.12.1');
    expect(requestedHosts, ['192.168.1.4']);
  });

  test('throws when the service information response is malformed', () async {
    serviceInfoHandler = (_) async => Response('Unavailable', 503);
    apiClient.setApiAddress('10.0.0.2:8080');

    final serviceInfo = apiClient.getServiceInfo();

    expect(serviceInfo, throwsA(isA<FormatException>()));
  });

  test('gets service information from a bracketed IPv6 endpoint', () async {
    final requestedUrls = <String>[];
    serviceInfoHandler = (request) async {
      requestedUrls.add(request.url.toString());
      return Response('{"version":"0.12.1"}', 200);
    };
    apiClient.setApiAddress('[2001:db8::4]:8080');

    await apiClient.getServiceInfo();

    expect(requestedUrls, ['http://[2001:db8::4]:8080/service/info']);
  });

  test('gets service information from a scoped IPv6 endpoint', () async {
    final requestedUrls = <String>[];
    serviceInfoHandler = (request) async {
      requestedUrls.add(request.url.toString());
      return Response('{"version":"0.12.1"}', 200);
    };
    apiClient.setApiAddress('[fe80::4%25en0]:8080');

    await apiClient.getServiceInfo();

    expect(requestedUrls, ['http://[fe80::4%25en0]:8080/service/info']);
  });
}
