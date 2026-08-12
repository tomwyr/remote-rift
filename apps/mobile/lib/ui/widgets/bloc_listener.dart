import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const BlocTransitionListener<S>({
  super.key,
  required final BlocBase<S> bloc,
  required final void Function(S previous, S current) listener,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<BlocTransitionListener<S>> createState() => _BlocTransitionListenerState<S>();
}

class _BlocTransitionListenerState<S> extends State<BlocTransitionListener<S>> {
  StreamSubscription? _subscription;
  late S _previous;

  @override
  void initState() {
    super.initState();
    _previous = widget.bloc.state;
    _listenStream();
  }

  @override
  void didUpdateWidget(covariant BlocTransitionListener<S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bloc != widget.bloc) {
      _listenStream();
    }
  }

  void _listenStream() {
    _subscription?.cancel();
    _subscription = widget.bloc.stream.listen((current) {
      widget.listener(_previous, current);
      _previous = current;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
