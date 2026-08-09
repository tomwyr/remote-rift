import 'package:flutter_test/flutter_test.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

void main() {
  test('normalizes resolved IPv4 service addresses', () {
    final addresses = ServiceAddress.normalizedAll(
      hosts: ['192.168.1.4.', '::1', '192.168.1.4', '127.0.0.1', '10.0.0.8'],
      port: 8080,
    );

    expect(addresses.map((address) => address.toAddressString()), [
      '192.168.1.4:8080',
      '10.0.0.8:8080',
    ]);
  });
}
