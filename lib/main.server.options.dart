// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:remote_rift_website/components/back_to_top.dart'
    as _back_to_top;
import 'package:remote_rift_website/components/navbar.dart' as _navbar;
import 'package:remote_rift_website/constants/theme.dart' as _theme;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _back_to_top.BackToTop: ClientTarget<_back_to_top.BackToTop>('back_to_top'),
    _navbar.Navbar: ClientTarget<_navbar.Navbar>('navbar'),
  },
  styles: () => [..._theme.styles],
);
