# Remote Rift API

Local API service and CLI wrapper around the League Client API.

## Overview

Remote Rift API wraps the **core** package, exposing it as a REST API and providing a minimal CLI to start the service.

When launched, the service starts an HTTP server that maps its endpoints to the **core** package's connector class. This allows clients to send commands and request data via HTTP, as well as receive continuous updates via WebSockets.

## Address resolution

When started with `--resolve-address`, the connector scans the host machine's network interfaces to find a usable local IPv4 address.
Automatic address resolution binds the service to a single suitable local network address.

> [!important]
> If no address or multiple addresses are detected, startup is aborted and the host must be configured manually.

## Assets

The project uses the `_generate_assets_` script from `remote_rift_tools` to embed text-based assets directly into the compiled executable. This approach overcomes the limitation of Dart projects that cannot bundle assets and avoids distributing additional files alongside the binary.

Running the script converts assets into `.asset.dart` files containing string constants. For example:

- `pubspec.yaml` -> `lib/src/assets/pubspec.asset.dart`

These files are then imported and used directly in the codebase.

> [!important]
> Because Dart does not yet support data assets in its build system, project assets must be generated manually whenever their source files change.

## Dependencies

This section describes selected third-party packages used throughout the application:

- [shelf](https://pub.dev/packages/shelf) - Lightweight HTTP server used to expose local APIs and handle incoming requests.

## Usage

1. Start the connector service API from the command line in one of the available modes:

   ```sh
   # Explicit host and port
   dart run remote_rift_api --host <host> --port <port>

   # Automatic address lookup
   dart run remote_rift_api --resolve-address
   ```

   The command will expose the service at `http://<host>:<port>` and `ws://<host>:<port>`.

> [!important]
> To be able to connect from another device, make sure to set the `host` parameter to the host device's local network address, for example:
> `dart run remote_rift_api --host 192.168.10.52 --port 8080`

2. Ensure the League client is running on the same machine.

## Development

To run the project locally:

1. Ensure Dart is installed.
2. Run `dart pub get` from the repository root to install dependencies.
3. Run the application from the `packages/api` directory in one of the available modes:

```sh
# Explicit host and port
dart run remote_rift_api --host <host> --port <port>

# Automatic address lookup
dart run remote_rift_api --resolve-address
```

> [!tip]
> Alternatively, run the _Connector: Resolve Address_ or _Connector: Custom Address_ launch configuration from VS Code and provide the required parameters.

4. After making changes to the source code, restart the service from the command line or use hot reload when running from an IDE.

### Building project

Run `dart compile exe lib/src/cli/main.dart -o build/remoterift` from the `packages/api` directory to compile the project into an executable.

> [!tip]
> Alternatively, use the `Connector: Build` VS Code task to compile the project. The resulting binary will be placed in `packages/api/build/remoterift`.

### Generating assets

Run `dart run remote_rift_tools:generate_asset pubspec lib/src/assets/pubspec.asset.dart` from the `packages/api` directory to generate the necessary assets as code.

> [!tip]
> Alternatively, use the `Connector: Generate Assets` VS Code task to generate assets. The resulting source will be placed in `packages/api/lib/src/assets`.
