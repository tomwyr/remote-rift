import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class McpSecretStore({required final FlutterSecureStorage _secureStorage}) {
  static const _secretKey = 'remote_rift_mcp_bearer_secret';

  Future<String> loadOrCreate() async {
    final storedSecret = await _secureStorage.read(key: _secretKey);
    if (storedSecret != null) return storedSecret;

    final secret = _newSecret();
    await _save(secret);
    return secret;
  }

  Future<String> reset() async {
    final secret = _newSecret();
    await _save(secret);
    return secret;
  }

  Future<void> _save(String secret) async {
    await _secureStorage.write(key: _secretKey, value: secret);
  }

  String _newSecret() {
    final random = Random.secure();
    final bytes = List.generate(32, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}
