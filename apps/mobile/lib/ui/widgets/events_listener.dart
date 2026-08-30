import 'dart:async';

import 'package:flutter/widgets.dart';

typedef EventsListenerOnEvent<T> = void Function(BuildContext context, T event);

class const EventsListener<T>({
  super.key,
  required final Stream<T> events,
  required final EventsListenerOnEvent<T> onEvent,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<EventsListener<T>> createState() => _EventsListenerState<T>();
}

class _EventsListenerState<T> extends State<EventsListener<T>> {
  StreamSubscription<T>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.events.listen(_onEvent);
  }

  void _onEvent(T event) {
    widget.onEvent(context, event);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
