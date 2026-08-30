import 'dart:async';

import 'package:bonsoir/bonsoir.dart';

import 'service_address.dart';

class ServiceRegistry({
  required final String _serviceName,
  required final String _serviceType,
}) {
  factory remoteRift() =>
      ServiceRegistry(serviceName: 'Remote Rift', serviceType: '_remoterift._tcp');

  Future<ServiceBroadcast> broadcast({required int port}) async {
    final broadcast = BonsoirBroadcast(
      service: BonsoirService(name: _serviceName, type: _serviceType, port: port),
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
    final discovery = BonsoirDiscovery(type: _serviceType);

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
            final addresses = ServiceAddress.resolveAll(hosts: hostAddresses, port: port);
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

class ServiceBroadcast(final BonsoirBroadcast _handler) {
  Future<void> dispose() async {
    await _handler.ensureStopped();
  }
}

extension on BonsoirActionHandler {
  Future<void> ensureStopped() async {
    if (!isStopped) {
      await stop();
    }
  }
}
