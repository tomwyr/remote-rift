import 'dart:convert';

extension McpHostConfiguration on Uri {
  String toHostConfiguration({required String bearerSecret}) {
    return const JsonEncoder.withIndent('  ').convert({
      'type': 'http',
      'url': toString(),
      'headers': {
        'Authorization': 'Bearer $bearerSecret',
      },
    });
  }
}
