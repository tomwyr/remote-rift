import 'dart:io';

import 'package:path/path.dart' as path;

void generatePubspecAsset(String targetPath) {
  print('Generating pubspec asset...');
  final rootPath = Directory.current.path;
  final pubspec = loadPackagePubspec(rootPath);
  final asset = renderPubspecAsset(pubspec);
  savePubspecAsset(rootPath, targetPath, asset);
  print('Successfully generated the asset');
}

String loadPackagePubspec(String rootPath) {
  final pubspecPath = path.join(rootPath, 'pubspec.yaml');
  print('Reading file contents from ${path.relative(pubspecPath)}');
  final file = File(pubspecPath);
  if (!file.existsSync()) {
    throw Exception(
      'The pubspec.yaml file was not found in the project (expected at ${file.path})',
    );
  }
  return file.readAsStringSync();
}

void savePubspecAsset(String rootPath, String targetPath, String contents) {
  final assetPath = path.joinAll([rootPath, targetPath]);
  print('Saving generated code under ${path.relative(assetPath)}');
  final file = File(assetPath);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  file.writeAsStringSync(contents);
}

String renderPubspecAsset(String contents) {
  return '''
class PubspecAsset {
  static Future<String> load() async => \'\'\'
$contents
\'\'\';
}
''';
}
