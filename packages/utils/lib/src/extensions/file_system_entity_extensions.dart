import 'dart:io';

import 'package:path/path.dart' as paths;

extension FileSystemEntityExtensions on FileSystemEntity {
  /// The last component of the entity's path.
  String get basename => paths.basename(path);
}
