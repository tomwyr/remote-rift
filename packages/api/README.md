# Remote Rift API

Local API service and CLI wrapper around the League Client API.

## Overview

Remote Rift API wraps the **core** package, exposing it as a REST API and providing a minimal CLI to start the service.

When launched, the service starts an HTTP server that maps its endpoints to the **core** package's connector class. This allows clients to send commands and request data via HTTP, as well as receive continuous updates via WebSockets.

## Address resolution

When started with `--resolve-address`, the CLI scans the host machine's network interfaces to find a usable local IPv4 address. This CLI-only mode binds the service to one selected address.

> [!important]
> If no address or multiple addresses are detected, startup is aborted and the host must be configured manually. This limitation does not apply to Remote Rift Desktop, which listens on all local IPv4 interfaces.

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
> To accept connections through every local IPv4 interface, use the wildcard bind address:
> `dart run remote_rift_api --host 0.0.0.0 --port 8080`
> Do not advertise `0.0.0.0` as a client address as clients must use a reachable address for the host.

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
