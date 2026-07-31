import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'config.dart';

class ApiServiceRepository {
  RemoteRiftApiServiceInfo getServiceInfo() {
    return RemoteRiftApiServiceInfo(version: ApiServiceConfig.version);
  }
}
