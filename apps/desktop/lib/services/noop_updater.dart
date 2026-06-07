import 'package:remote_rift_updater/remote_rift_updater.dart';

class NoopUpdater implements ApplicationUpdater {
  @override
  Future<AvailableUpdate?> checkUpdateAvailable() async => null;

  @override
  Future<void> installUpdate({required AvailableUpdate update}) async {}
}
