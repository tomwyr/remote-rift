import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../common/assets.dart';
import '../connection/connection_component.dart';
import '../connection/connection_cubit.dart';
import '../connection/connection_state.dart';
import '../game/game_component.dart';

class const HomePage({super.key}) extends StatelessWidget {
  static Widget builder() {
    return BlocProvider(
      create: Dependencies.connectionCubit,
      child: HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ConnectionCubit>().state;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        leading: Padding(
          padding: context.remoteRiftTheme.appBarLeadingPadding,
          child: Image.asset(Assets.logo),
        ),
        title: Text(t.app.title, style: Theme.of(context).textTheme.titleLarge),
        actions: [_ConnectionStatusIcon(state: state)],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const .fromLTRB(20, 16, 20, 0),
          child: ConnectionComponent(
            connectedBuilder: (_) => GameComponent.builder(),
          ),
        ),
      ),
    );
  }
}

class const _ConnectionStatusIcon({
  required final ConnectionState state,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;
    final isConnected = state is Connected;
    final label = state.statusLabel;

    return Padding(
      padding: const .only(right: 20),
      child: Tooltip(
        message: label,
        child: Semantics(
          label: label,
          child: Icon(
            isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
            color: isConnected ? colors.ready : colors.gold,
          ),
        ),
      ),
    );
  }
}
