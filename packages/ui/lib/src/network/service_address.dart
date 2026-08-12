import 'dart:io';

class ServiceAddress {
  ServiceAddress(this.addressString);

  final String addressString;

  static ServiceAddress? resolve({required String host, required int port}) {
    final normalizedHost = host.endsWith('.') ? host.substring(0, host.length - 1) : host;
    return normalizedHost.contains(':')
        ? _resolveIpv6(host: normalizedHost, port: port)
        : _resolveIpv4(host: normalizedHost, port: port);
  }

  static List<ServiceAddress> resolveAll({
    required List<String> hosts,
    required int port,
  }) {
    final addresses = <ServiceAddress>[];
    final seenHosts = <String>{};

    for (final host in hosts) {
      final address = resolve(host: host, port: port);
      if (address == null) continue;
      if (seenHosts.add(address.addressString)) {
        addresses.add(address);
      }
    }

    return addresses;
  }

  static ServiceAddress? _resolveIpv4({required String host, required int port}) {
    final address = InternetAddress.tryParse(host);
    if (address == null || address.type != .IPv4 || !address.isUsableForConnection) {
      return null;
    }
    return .new('${address.address}:$port');
  }

  static ServiceAddress? _resolveIpv6({required String host, required int port}) {
    final (ipLiteral, scope) = _splitIpv6Host(host);

    final address = InternetAddress.tryParse(ipLiteral);
    if (address == null || address.type != .IPv6 || !address.isUsableForConnection) {
      return null;
    }
    if (scope == '' || scope == null && address.isLinkLocal) {
      return null;
    }

    if (scope == null) {
      return .new('[${address.address}]:$port');
    } else {
      final encodedScope = Uri.encodeComponent(scope);
      return .new('[${address.address}%25$encodedScope]:$port');
    }
  }

  static (String ipLiteral, String? scope) _splitIpv6Host(String host) {
    final scopeSeparator = host.indexOf('%');
    if (scopeSeparator == -1) {
      return (host, null);
    }
    return (host.substring(0, scopeSeparator), host.substring(scopeSeparator + 1));
  }
}

extension on InternetAddress {
  bool get isUsableForConnection {
    return !isLoopback && !isUnspecified;
  }

  bool get isUnspecified {
    final anyAddress = type == .IPv4 ? InternetAddress.anyIPv4 : InternetAddress.anyIPv6;
    return this == anyAddress;
  }
}
