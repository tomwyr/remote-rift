import 'dart:io';

import 'package:remote_rift_api/remote_rift_api.dart';
import 'package:test/test.dart';

void main() {
  test('binds an IPv6-only listener when supported by the host', () async {
    HttpServer? server;

    try {
      server = await RemoteRiftApiService().run(
        host: InternetAddress.anyIPv6.address,
        port: 0,
      );

      expect(server.address.type, InternetAddressType.IPv6);
    } on SocketException {
      // IPv6 may be disabled by the host or CI environment.
    } finally {
      await server?.close();
    }
  });
}
