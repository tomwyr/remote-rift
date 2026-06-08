import 'dart:io';

import 'package:path/path.dart' as path;

import 'generate_asset/pubspec.dart';

void main(List<String> args) async {
  final (type, targetPath) = parseCommandArgs(args);
  switch (type) {
    case .pubspec:
      generatePubspecAsset(targetPath);
  }
}

(AssetType, String) parseCommandArgs(List<String> args) {
  final type = parseAssetType(args.elementAtOrNull(0));
  final targetPath = parseTargetPath(args.elementAtOrNull(1));
  return (type, targetPath);
}

AssetType parseAssetType(String? arg) {
  if (arg == null || arg.isEmpty) {
    print('Asset type argument is required');
    exit(1);
  }

  try {
    return .values.byName(arg);
  } on ArgumentError {
    print('Unknown asset type: $arg. Available types: pubspec.');
    exit(1);
  }
}

String parseTargetPath(String? arg) {
  if (arg == null || arg.isEmpty) {
    print('Target path argument is required');
    exit(1);
  }
  if (!path.isRelative(arg)) {
    print('Target path must be relative to the package root');
    exit(1);
  }

  return arg;
}

enum AssetType { pubspec }
