import 'dart:async';
import 'dart:io';

import 'package:bonsoir/bonsoir.dart';

class ServiceRegistry {
  ServiceRegistry({required this.serviceName, required this.serviceType});

  factory ServiceRegistry.remoteRift() =>
      ServiceRegistry(serviceName: 'Remote Rift', serviceType: '_remoterift._tcp');

  final String serviceName;
  final String serviceType;

  Future<ServiceBroadcast> broadcast({required int port}) async {
    final broadcast = BonsoirBroadcast(
      service: BonsoirService(name: serviceName, type: serviceType, port: port),
    );

    try {
      await broadcast.initialize();
      await broadcast.start();
      return ServiceBroadcast(broadcast);
    } catch (error) {
      await broadcast.ensureStopped();
      rethrow;
    }
  }

  Future<List<ServiceAddress>> discover({Duration? timeLimit}) async {
    final discovery = BonsoirDiscovery(type: serviceType);

    try {
      await discovery.initialize();

      /// Start listening for the service before running the discovery to avoid
      /// missing the result event while the listener is being set.
      var result = _resolveService(discovery);
      if (timeLimit != null) {
        result = result.timeout(timeLimit);
      }
      await discovery.start();
      return await result;
    } on TimeoutException {
      return [];
    } finally {
      await discovery.ensureStopped();
    }
  }

  Future<List<ServiceAddress>> _resolveService(BonsoirDiscovery discovery) async {
    final eventStream = discovery.eventStream ?? .empty();

    await for (var event in eventStream) {
      switch (event) {
        case BonsoirDiscoveryServiceFoundEvent():
          event.service.resolve(discovery.serviceResolver);

        case BonsoirDiscoveryServiceResolvedEvent():
          if (event.service case BonsoirService(:var hostAddresses, :var port)) {
            final addresses = ServiceAddress.normalizedAll(hosts: hostAddresses, port: port);
            if (addresses.isNotEmpty) {
              return addresses;
            }
          }

        default:
        // Not interested in other types of events
      }
    }

    return [];
  }
}

class ServiceBroadcast {
  ServiceBroadcast(this._handler);

  final BonsoirBroadcast _handler;

  Future<void> dispose() async {
    await _handler.ensureStopped();
  }
}

class ServiceAddress {
  ServiceAddress({required this.host, required this.port});

  factory ServiceAddress.normalized({required String host, required int port}) {
    // Remove trailing period from host if it's a fully qualified domain name.
    final normalizedHost = host.endsWith('.') ? host.substring(0, host.length - 1) : host;
    return .new(host: normalizedHost, port: port);
  }

  static List<ServiceAddress> normalizedAll({
    required List<String> hosts,
    required int port,
  }) {
    final addresses = <ServiceAddress>[];
    final seenHosts = <String>{};

    for (final host in hosts) {
      final address = ServiceAddress.normalized(host: host, port: port);
      final alreadySeen = !seenHosts.add(address.host);
      if (address.eligibleForConnection && !alreadySeen) {
        addresses.add(address);
      }
    }

    return addresses;
  }

  final String host;
  final int port;

  String toAddressString() {
    return '$host:$port';
  }
}

extension on ServiceAddress {
  bool get eligibleForConnection {
    final internetAddress = InternetAddress.tryParse(host);
    return internetAddress != null && internetAddress.type == .IPv4 && !internetAddress.isLoopback;
  }
}

extension on BonsoirActionHandler {
  Future<void> ensureStopped() async {
    if (!isStopped) {
      await stop();
    }
  }
}
