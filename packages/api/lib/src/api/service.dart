import 'dart:io';

import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:shelf/shelf_io.dart';

import 'routes/router.dart';

class RemoteRiftApiService({
  RemoteRiftConnector Function()? createConnector,
  final ConnectorFailureObserver? _onFailure,
}) {
  final _createConnector = createConnector ?? (() => RemoteRiftConnector());

  Future<HttpServer> run({required String host, required int port}) async {
    final router = ConnectorRoutes.configure(_createConnector, _onFailure);
    final server = await HttpServer.bind(host, port, v6Only: true);
    serveRequests(server, router.call);
    final authority = host.contains(':') ? '[$host]:$port' : '$host:$port';
    print('Serving HTTP at http://$authority');
    print('WebSocket connections at ws://$authority');
    return server;
  }
}
