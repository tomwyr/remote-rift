import 'dart:io';

void main(List<String> arguments) {
  final version = _parseVersion(arguments);
  for (var path in _scanPubspecPaths()) {
    _updateVersionAtPath(version, path);
  }
  print('Updated all pubspec versions to $version');
}

String _parseVersion(List<String> arguments) {
  if (arguments.length != 1) {
    print('Version argument is required.');
    exit(1);
  }

  final version = arguments[0];

  if (!_isSemantic(version)) {
    print('Version must be in semantic format: e.g. 1.2.3');
    exit(1);
  }

  return version;
}

bool _isSemantic(String version) {
  final pattern = r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$';
  return RegExp(pattern).hasMatch(version);
}

List<String> _scanPubspecPaths() {
  final paths = <String>[];

  final rootPubspec = File('./pubspec.yaml');
  if (!rootPubspec.existsSync()) {
    print('Root pubspec.yaml not found!');
    exit(1);
  }
  paths.add(rootPubspec.path);

  for (var pkg in _scanPackageDirectories()) {
    final pubspec = File('./${pkg.path}/pubspec.yaml');
    if (!pubspec.existsSync()) {
      print('${pkg.path} does not contain a pubspec.yaml');
      exit(1);
    }
    paths.add(pubspec.path);
  }

  return paths;
}

List<Directory> _scanPackageDirectories() {
  final packagesDir = Directory('packages');
  if (packagesDir.existsSync()) {
    return packagesDir.listSync().whereType<Directory>().toList();
  } else {
    return [];
  }
}

void _updateVersionAtPath(String version, String path) {
  print('Updating $path...');
  final sedInplace = Platform.isMacOS ? ['-i', ''] : ['-i'];
  final replacePattern = 's/^\\([[:space:]]*version:\\).*/\\1 $version/';
  Process.runSync('sed', [...sedInplace, replacePattern, path], runInShell: true);
}
