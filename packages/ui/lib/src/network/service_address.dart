import 'dart:io';

class ServiceAddress {
  ServiceAddress._({
    required this.host,
    required this.port,
    required this.isIpv6,
  });

  final String host;
  final int port;
  final bool isIpv6;

  String toAddressString() {
    if (isIpv6) {
      return '[${_ipv6Host()}]:$port';
    } else {
      return '$host:$port';
    }
  }

  String _ipv6Host() {
    final scopeSeparator = host.indexOf('%');
    if (scopeSeparator == -1) return host;

    final (ipLiteral, scope) = (
      host.substring(0, scopeSeparator),
      host.substring(scopeSeparator + 1),
    );
    final encodedScope = Uri.encodeComponent(scope);
    return '$ipLiteral%25$encodedScope';
  }

  static ServiceAddress? resolve({required String host, required int port}) {
    final normalizedHost = host.endsWith('.') ? host.substring(0, host.length - 1) : host;
    final address = InternetAddress.tryParse(normalizedHost);
    if (address == null || !address.isUsableForConnection()) {
      return null;
    }

    return ServiceAddress._(
      host: address.address,
      port: port,
      isIpv6: address.type == .IPv6,
    );
  }

  static List<ServiceAddress> resolveAll({
    required List<String> hosts,
    required int port,
  }) {
    final addresses = <ServiceAddress>[];
    final seenHosts = <String>{};

    for (final host in hosts) {
      final serviceAddress = resolve(host: host, port: port);
      if (serviceAddress == null) continue;
      if (seenHosts.add(serviceAddress.host)) {
        addresses.add(serviceAddress);
      }
    }

    return addresses;
  }
}

extension on InternetAddress {
  bool isUsableForConnection() {
    if (isLoopback || isUnspecified) return false;
    final hasScope = address.contains('%');
    return type == .IPv4 || !(isLinkLocal && !hasScope);
  }

  bool get isUnspecified {
    final anyAddress = type == .IPv4 ? InternetAddress.anyIPv4 : InternetAddress.anyIPv6;
    return this == anyAddress;
  }
}
