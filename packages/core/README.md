# Remote Rift Core

League Client API integration and connector service.

## Overview

Remote Rift Core provides integration with the LCU API and exposes a service to interact with the game client.

It acts as a lightweight adapter that manages LCU connections and translates high-level client actions into LCU API calls.

## Authentication

The LCU API requires authenticating using credentials obtained from a lockfile stored in the game directory while the client is running. When connecting to the LCU API, the service attempts to read the credentials automatically from the default location based on the host operating system.

If the service is launched while the League client is not active or if the lockfile is missing, the connector API will be unable to communicate with the game and will return a relevant error response.
