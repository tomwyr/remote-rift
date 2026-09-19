import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/mcp_server_runner.dart';
import 'mcp_integration_state.dart';

class McpIntegrationCubit({required final McpServerRunner _runner})
    extends Cubit<McpIntegrationState> {
  this : super(Idle());

  void enable() async {
    if (state case Starting() || Running()) {
      throw StateError(
        'Tried to enable while already starting or running (was ${state.runtimeType})',
      );
    }

    await _runServer(.start, _runner.enable);
  }

  void disable() async {
    try {
      await _runner.disable();
      emit(Idle());
    } catch (_) {
      emit(Failed(action: .stop));
    }
  }

  void reset() async {
    if (state is! Running) {
      throw StateError(
        'Tried to reset while not running (was ${state.runtimeType})',
      );
    }

    await _runServer(.reset, _runner.reset);
  }

  Future<void> _runServer(McpAction action, Future<McpServerRunInfo> Function() run) async {
    emit(Starting());
    try {
      final info = await run();
      emit(Running(hostConfiguration: info.hostConfiguration));
    } catch (_) {
      emit(Failed(action: action));
    }
  }

  @override
  Future<void> close() async {
    await _runner.disable();
    await super.close();
  }
}
