# Remote Rift

Remote Rift lets you queue for League of Legends games from your phone.

## Overview

Remote Rift is a cross-platform companion system for controlling League of Legends matchmaking from a phone. It lets users step away from the PC while still monitoring queue progress and responding to ready-check events.

Remote Rift provides:

- **Remote queue control** - Select a queue, create or leave a lobby, start or stop matchmaking, and accept or decline a found match.
- **Live status updates** - View the current lobby, queue, ready-check, and game-client connection state from the mobile application.
- **Desktop connector** - Run the local service, display connection status, integrate with the system tray, discover the service automatically on the local network, and prompt for updates.

## Implementation

Remote Rift is implemented as a Dart workspace with Flutter applications for mobile and desktop, a Jaspr-based website, and shared packages for common runtime and development logic.

Technical highlights:

- **Local API service** - Built with `shelf`, exposing REST endpoints for commands and WebSocket streams for continuous status updates.
- **LCU integration** - The core package wraps League Client API communication and translates high-level actions into LCU requests.
- **Local discovery** - Shared UI utilities use mDNS service discovery so mobile clients can find the desktop service automatically.
- **Desktop updates** - The updater package uses GitHub Releases to check, download, and install new desktop application versions.

## Workspace

The workspace is organized around user-facing applications and the packages that support them.

### Applications

- [Mobile](apps/mobile) - Mobile application allowing remote interaction with the League client.
- [Desktop](apps/desktop) - Desktop application exposing connection to the League Client.
- [Website](apps/website) - Landing page showcasing the application and guiding users on getting started.

### Packages

- [API](packages/api) - Local API service and CLI wrapper around the League Client API.
- [Core](packages/core) - League Client API integration and connector service.
- [UI](packages/ui) - Shared UI, theming and Flutter dependent utilities.
- [Utils](packages/utils) - Shared Dart utilities and common data models.
- [Tools](packages/tools) - Scripts and utilities used during development.
- [Updater](packages/updater) - Service enabling application updates at runtime.

## Releases

Remote Rift projects are built and published through GitHub Actions.

Mobile and Desktop builds are available from the [GitHub Releases page](https://github.com/tomwyr/remote-rift/releases). Mobile builds can be downloaded and installed manually until the application is available through app stores.

> [!NOTE]
> iOS builds are unsigned and require an appropriate Apple distribution method before they can be installed.

Website releases are published to GitHub Pages. The current website version is available at [tomwyr.github.io/remote-rift](https://tomwyr.github.io/remote-rift/).
