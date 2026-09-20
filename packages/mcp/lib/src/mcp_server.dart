import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import 'mcp_tools.dart';

class RemoteRiftMcpServer({
  required final RemoteRiftConnector _connector,
  required final String _bearerSecret,
  final int _port = defaultPort,
}) {
  static const defaultPort = 46321;

  StreamableMcpServer? _server;

  bool get isRunning => _server != null;

  Future<Uri> start() async {
    if (_server case var server?) return server.endpoint;

    final server = _createTransportServer();
    try {
      await server.start();
      _server = server;
      return server.endpoint;
    } on SocketException catch (error) {
      await server.stop();
      throw BindError(cause: error);
    } catch (error) {
      await server.stop();
      throw StartError(cause: error);
    }
  }

  Future<void> stop() async {
    final server = _server;
    _server = null;
    if (server == null) return;

    try {
      await server.stop();
    } catch (error) {
      throw StopError(cause: error);
    }
  }

  StreamableMcpServer _createTransportServer() => StreamableMcpServer(
    serverFactory: (_) => _createMcpServer(),
    host: '127.0.0.1',
    port: _port,
    path: '/mcp',
    enableJsonResponse: true,
    allowedHosts: const {'127.0.0.1', 'localhost'},
    authenticationHandler: _authenticate,
  );

  McpServer _createMcpServer() {
    return McpServer(
      const Implementation(name: 'remote-rift', version: '0.1.0'),
      options: const McpServerOptions(protocol: .stable),
    )..configure(this, _connector);
  }

  StreamableMcpAuthenticationResult _authenticate(Object? request) {
    if (request case HttpRequest request) {
      final authorization = request.headers.value(HttpHeaders.authorizationHeader);
      if (authorization == 'Bearer $_bearerSecret') return const .allow();
    }
    return const .unauthorized(errorDescription: 'A valid bearer token is required.');
  }
}

extension on StreamableMcpServer {
  Uri get endpoint => Uri(scheme: 'http', host: host, port: boundPort, path: path);
}

sealed class const RemoteRiftMcpServerError({required final Object cause}) implements Exception;

class const BindError({required super.cause}) extends RemoteRiftMcpServerError;

class const StartError({required super.cause}) extends RemoteRiftMcpServerError;

class const StopError({required super.cause}) extends RemoteRiftMcpServerError;
