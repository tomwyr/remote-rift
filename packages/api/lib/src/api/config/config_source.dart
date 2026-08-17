sealed class RemoteRiftApiConfigSource {
  factory environment() = EnvironmentSource;
  factory systemLookup({
    SystemLookupAddressResolver? resolveAddress,
  }) = SystemLookupSource;
}

class EnvironmentSource implements RemoteRiftApiConfigSource;

typedef SystemLookupAddressResolver = String Function(List<String> availableAddresses);

class SystemLookupSource({
  final SystemLookupAddressResolver? resolveAddress,
}) implements RemoteRiftApiConfigSource;
