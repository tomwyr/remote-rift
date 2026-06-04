// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:remote_rift_website/components/back_to_top.dart'
    deferred as _back_to_top;
import 'package:remote_rift_website/components/navbar.dart' deferred as _navbar;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'back_to_top': ClientLoader(
      (p) => _back_to_top.BackToTop(),
      loader: _back_to_top.loadLibrary,
    ),
    'navbar': ClientLoader(
      (p) => _navbar.Navbar(),
      loader: _navbar.loadLibrary,
    ),
  },
);
