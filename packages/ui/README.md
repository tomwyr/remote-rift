# Remote Rift UI

Shared UI, theming and Flutter dependent utilities.

## Service discovery

The project uses mDNS to enable automatic service discovery and registration on the local network. When the connector service starts, it advertises itself using the `_remoterift._tcp` service type, allowing Remote Rift mobile and desktop clients to detect and connect to the service without manual configuration.

This is achieved through the [Bonsoir](https://pub.dev/packages/bonsoir) package, which handles broadcasting the service and discovering available instances on the network. For more information on how service discovery and registration work, see the [ServiceRegistry](./lib/src/network/service_registry.dart) class.

The desktop service listens on all local IPv4 interfaces and the mobile client tries every IPv4 endpoint returned for the resolved service. Discovery remains link-local: devices must be on a network that permits mDNS and direct TCP communication. Guest Wi-Fi, client isolation, VLANs, routed-network boundaries, firewalls, and multicast filtering can prevent discovery.

## Dependencies

This section describes selected third-party packages used throughout the project:

- [bonsoir](https://pub.dev/packages/bonsoir) - mDNS/DNS-SD service discovery for advertising and discovering services on the local network.
