import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';
import 'package:uuid/uuid.dart';

abstract final class DesktopLogger {
  static Future<AppLogger> open() async {
    final supportDirectory = await getApplicationSupportDirectory();
    final directory = Directory(path.join(supportDirectory.path, 'diagnostics'));
    final packageInfo = await PackageInfo.fromPlatform();
    return await AppLogger.open(
      storageDirectory: directory,
      app: 'desktop',
      appVersion: packageInfo.version,
      sessionId: const Uuid().v4(),
    );
  }
}
