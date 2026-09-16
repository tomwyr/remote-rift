import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import '../home/home_page.dart';
import '../mcp/mcp_integration_component.dart';
import '../update/update_component.dart';
import 'app_notifications.dart';

class const App({super.key}) extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: t.app.title,
      theme: RemoteRiftTheme.light(buttonVariant: .small),
      builder: (context, child) => RemoteRiftTheme.builder(
        child: AppNotifications(
          navigatorKey: _navigatorKey,
          child: UpdateComponent.builder(
            child: McpIntegrationComponent.builder(child: child!),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
