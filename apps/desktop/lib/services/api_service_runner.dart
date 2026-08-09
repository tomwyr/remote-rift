import 'dart:io';

import 'package:remote_rift_api/remote_rift_api.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

class RemoteRiftApiServiceRunner {
  RemoteRiftApiServiceRunner({required this.service, required this.registry});

  final RemoteRiftApiService service;
  final ServiceRegistry registry;

  HttpServer? _server;
  ServiceBroadcast? _broadcast;

  var _running = false;

  Future<void> run() async {
    if (_running) return;
    _running = true;

    try {
      final (server, broadcast) = await _runAndBroadcast();
      _server = server;
      _broadcast = broadcast;
    } catch (_) {
      close();
      rethrow;
    }
  }

  Future<(HttpServer, ServiceBroadcast)> _runAndBroadcast() async {
    final port = RemoteRiftApiConfig.defaultPort;
    final server = await service.run(host: InternetAddress.anyIPv4.address, port: port);
    final broadcast = await registry.broadcast(port: port);
    return (server, broadcast);
  }

  Future<void> close() async {
    await _broadcast?.dispose();
    await _server?.close();
    _broadcast = null;
    _server = null;
    _running = false;
  }
}
