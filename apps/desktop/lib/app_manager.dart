import 'dart:async';
import 'dart:io' as os;

final appManager = AppManager._();

class AppManager {
  AppManager._();

  final _exitListeners = <FutureOr<void> Function()>{};

  void addExitListener(FutureOr<void> Function() listener) {
    _exitListeners.add(listener);
  }

  void removeExitListener(FutureOr<void> Function() listener) {
    _exitListeners.remove(listener);
  }

  void exit() async {
    try {
      await _notifyListeners();
    } finally {
      os.exit(0);
    }
  }

  Future<void> _notifyListeners() async {
    for (var listener in _exitListeners) {
      await listener();
    }
  }
}
