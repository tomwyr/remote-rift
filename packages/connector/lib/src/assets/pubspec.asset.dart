class PubspecAsset {
  static Future<String> load() async => '''
name: remote_rift_connector
publish_to: none
version: 0.12.1

resolution: workspace

environment:
  sdk: ^3.10.0

dependencies:
  args: ^2.7.0
  hooks: ^1.0.0
  path: ^1.9.1
  pubspec_parse: ^1.5.0
  shelf: ^1.4.2
  shelf_router: ^1.1.4
  shelf_web_socket: ^3.0.0
  web_socket_channel: ^3.0.3

  remote_rift_core: ^0.12.1
  remote_rift_utils: ^0.9.0

dev_dependencies:
  test: ^1.25.6

  remote_rift_tools: ^0.9.0

''';
}
