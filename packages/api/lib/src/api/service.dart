import 'dart:io';

import 'package:shelf/shelf_io.dart';

import 'routes/router.dart';

class RemoteRiftApiService {
  Future<HttpServer> run({required String host, required int port}) async {
    final router = configureRouter();
    final server = await HttpServer.bind(host, port, v6Only: true);
    serveRequests(server, router.call);
    final authority = host.contains(':') ? '[$host]:$port' : '$host:$port';
    print('Serving HTTP at http://$authority');
    print('WebSocket connections at ws://$authority');
    return server;
  }
}
