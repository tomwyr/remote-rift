import 'package:flutter_test/flutter_test.dart';
import 'package:remote_rift_ui/src/network/service_address.dart';

void main() {
  test('normalizes and formats usable resolved service addresses', () {
    final addresses = ServiceAddress.resolveAll(
      hosts: [
        '192.168.1.4.',
        '2001:db8::4',
        'fe80::4',
        'fe80::4%en0',
        '::1',
        '::',
        '0.0.0.0',
        '192.168.1.4',
        '127.0.0.1',
        '10.0.0.8',
      ],
      port: 8080,
    );

    expect(addresses.map((address) => address.toAddressString()), [
      '192.168.1.4:8080',
      '[2001:db8::4]:8080',
      '[fe80::4%25en0]:8080',
      '10.0.0.8:8080',
    ]);
  });

  test('deduplicates repeated IPv6 addresses with the same scope', () {
    final addresses = ServiceAddress.resolveAll(
      hosts: ['2001:db8::4', '2001:db8::4', 'fe80::4%en0', 'fe80::4%en1'],
      port: 8080,
    );

    expect(addresses.map((address) => address.toAddressString()), [
      '[2001:db8::4]:8080',
      '[fe80::4%25en0]:8080',
      '[fe80::4%25en1]:8080',
    ]);
  });
}
