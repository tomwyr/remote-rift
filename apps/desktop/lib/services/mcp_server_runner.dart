import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_mcp/remote_rift_mcp.dart';

import 'mcp_host_configuration.dart';
import 'mcp_secret_store.dart';

class McpServerRunner({
  required final RemoteRiftConnector _connector,
  required final McpSecretStore _secretStore,
}) {
  RemoteRiftMcpServer? _server;
  Uri? _endpoint;
  String? _secret;

  bool get isRunning => _server?.isRunning ?? false;

  Future<McpServerRunInfo> enable() async {
    final secret = _secret ??= await _secretStore.loadOrCreate();
    final endpoint = _endpoint ??= await _startServer(secret);
    return McpServerRunInfo(
      endpoint: endpoint,
      hostConfiguration: endpoint.toHostConfiguration(bearerSecret: secret),
    );
  }

  Future<Uri> _startServer(String secret) async {
    final server = RemoteRiftMcpServer(
      connector: _connector,
      bearerSecret: secret,
    );
    try {
      final endpoint = await server.start();
      _server = server;
      _endpoint = endpoint;
      return endpoint;
    } catch (_) {
      await server.stop();
      rethrow;
    }
  }

  Future<void> disable() async {
    final server = _server;
    _server = null;
    _endpoint = null;
    await server?.stop();
  }

  Future<McpServerRunInfo> reset() async {
    await disable();
    _secret = await _secretStore.reset();
    return await enable();
  }
}

class const McpServerRunInfo({
  required final Uri endpoint,
  required final String hostConfiguration,
});
