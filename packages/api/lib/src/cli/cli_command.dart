sealed class RemoteRiftCliCommand {}

class Help extends RemoteRiftCliCommand {}

class Run({
  required final String host,
  required final int port,
}) extends RemoteRiftCliCommand {}

class RunWithAddressLookup extends RemoteRiftCliCommand {}

class Invalid extends RemoteRiftCliCommand {}
