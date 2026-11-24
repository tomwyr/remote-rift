import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:basic_utils/basic_utils.dart'
    show CryptoUtils, ECPrivateKey, ECPublicKey, X509Utils;
import 'package:path/path.dart' as p;
import 'package:remote_rift_core/lcu_protocol.dart';
import 'package:shelf/shelf_io.dart';

import '../simulation/simulator.dart';
import 'simulator_routes.dart';

class SimulatorServer._(final HttpServer _server, final File _lockfile, final String _contents) {
  String get lockfilePath => _lockfile.path;

  static Future<SimulatorServer> start(Simulator simulator, Directory directory) async {
    final host = InternetAddress.loopbackIPv4;
    final context = _createSecurityContext(host.address);
    final random = Random.secure();
    final password = base64UrlEncode(List.generate(32, (_) => random.nextInt(256)));
    final authorization = 'Basic ${base64Encode(utf8.encode('riot:$password'))}';
    final lockfile = File(p.join(directory.path, LcuSimulatorProtocol.lockfileName));
    final staged = File('${lockfile.path}.$pid.tmp');

    await directory.create(recursive: true);
    final server = await HttpServer.bindSecure(host, 0, context);
    try {
      final routes = SimulatorRoutes(simulator, authorization);
      serveRequests(server, routes.handler);
      final contents = 'LeagueClientSimulator:$pid:${server.port}:$password:https';
      await staged.writeAsString(contents, flush: true);
      await staged.rename(lockfile.path);
      return SimulatorServer._(server, lockfile, contents);
    } catch (_) {
      await server.close(force: true);
      if (await staged.exists()) {
        await staged.delete();
      }
      rethrow;
    }
  }

  Future<void> close() async {
    await _server.close(force: true);
    if (await _lockfile.exists() && await _lockfile.readAsString() == _contents) {
      await _lockfile.delete();
    }
  }

  static SecurityContext _createSecurityContext(String host) {
    final keyPair = CryptoUtils.generateEcKeyPair();
    final privateKey = keyPair.privateKey;
    final publicKey = keyPair.publicKey;
    if (privateKey is! ECPrivateKey || publicKey is! ECPublicKey) {
      throw StateError('Expected an elliptic curve key pair');
    }
    final request = X509Utils.generateEccCsrPem({'CN': host}, privateKey, publicKey);
    final certificate = X509Utils.generateSelfSignedCertificate(privateKey, request, 1);
    final key = CryptoUtils.encodePrivateEcdsaKeyToPkcs8(privateKey);

    return SecurityContext()
      ..useCertificateChainBytes(utf8.encode(certificate))
      ..usePrivateKeyBytes(utf8.encode(key));
  }
}
