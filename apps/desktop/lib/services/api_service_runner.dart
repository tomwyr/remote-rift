import 'dart:io';

import 'package:remote_rift_api/remote_rift_api.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

class RemoteRiftApiServiceRunner({
  required final RemoteRiftApiService _service,
  required final ServiceRegistry _registry,
}) {
  List<HttpServer> _servers = [];
  ServiceBroadcast? _broadcast;

  var _running = false;

  Future<void> run() async {
    if (_running) return;
    _running = true;

    try {
      final (servers, broadcast) = await _runAndBroadcast();
      _servers = servers;
      _broadcast = broadcast;
    } catch (_) {
      await close();
      rethrow;
    }
  }

  Future<(List<HttpServer>, ServiceBroadcast)> _runAndBroadcast() async {
    final port = RemoteRiftApiConfig.defaultPort;
    final servers = <HttpServer>[];

    Future<void> runServerOn(InternetAddress address) async {
      final host = address.address;
      final server = await _service.run(host: host, port: port);
      servers.add(server);
    }

    try {
      await runServerOn(InternetAddress.anyIPv4);
      try {
        await runServerOn(InternetAddress.anyIPv6);
      } on SocketException {
        // Keep the IPv4 listener available on hosts where IPv6 is disabled.
      }

      final broadcast = await _registry.broadcast(port: port);
      return (servers, broadcast);
    } catch (_) {
      await servers.map((server) => server.close()).wait;
      rethrow;
    }
  }

  Future<void> close() async {
    await _broadcast?.dispose();
    await _servers.map((server) => server.close()).wait;
    _broadcast = null;
    _servers = [];
    _running = false;
  }
}
