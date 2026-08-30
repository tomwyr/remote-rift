import 'package:remote_rift_updater/remote_rift_updater.dart';

class NoopUpdater implements ApplicationUpdater {
  @override
  Future<void> acknowledgeHealthyStart() async {}

  @override
  Future<UpdateRelease?> checkUpdateAvailable() async => null;

  @override
  Future<void> installUpdate({required UpdateRelease update}) async {}
}
