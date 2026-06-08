# Remote Rift

Remote Rift lets you queue for League of Legends games from your phone.

This repository is a Dart and Flutter monorepo using Pub workspaces.

## Projects

- [Mobile](apps/mobile) - Flutter app for Android and iOS.
- [Desktop](apps/desktop) - Flutter app for Windows and macOS that runs the local connector service.
- [Website](apps/website) - Jaspr static website deployed to GitHub Pages.
- [Connector](packages/connector) - Local REST and WebSocket API around the League Client API.
- [Core](packages/core) - League Client API integration and Remote Rift state model.
- [UI](packages/ui) - Shared Flutter UI and mDNS service discovery.
- [Utils](packages/utils) - Shared Dart utilities.
- [Tools](packages/tools) - Development scripts.
- [Application Updater](packages/application_updater) - Desktop runtime update package.

## Development

Install dependencies from the repository root:

```sh
dart pub get
```

List workspace packages:

```sh
dart pub workspace list
```

Run analysis from the repository root:

```sh
dart analyze
```

Future releases are published from this repository using scoped tags in `<package>-<version>` format, for example `desktop-1.2.3`.
