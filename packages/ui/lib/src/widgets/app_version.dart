import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../theme/theme_extension.dart';

class const AppVersion({super.key}) extends StatefulWidget {
  @override
  State<AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
  late final _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return FutureBuilder(
      future: _packageInfo,
      builder: (context, snapshot) {
        if (snapshot.data?.version case var version?) {
          return Text(
            'v$version',
            textAlign: .center,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: colors.navy.withValues(alpha: 0.72)),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
