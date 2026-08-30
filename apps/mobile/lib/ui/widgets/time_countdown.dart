import 'package:flutter/material.dart';
import 'package:time/time.dart';

typedef TimeCountdownBuilder = Widget Function(double progress, double seconds);

class const TimeCountdown({
  super.key,
  required final double start,
  required final double current,
  required final double drift,
  required final TimeCountdownBuilder builder,
}) extends StatefulWidget {
  this
    : assert(
        current >= 0 && start > 0 && current <= start,
        'Current time cannot be negative or exceed start.',
      );

  @override
  State<TimeCountdown> createState() => _TimeCountdownState();
}

class _TimeCountdownState extends State<TimeCountdown> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double get _controllerCurrent => _controller.value * widget.start;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
  }

  @override
  void didUpdateWidget(covariant TimeCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    startChanged() {
      return oldWidget.start != widget.start;
    }

    currentChangeExceedsDrift() {
      if (oldWidget.current != widget.current) {
        final currentDiff = (widget.current - _controllerCurrent).abs();
        return currentDiff > widget.drift;
      }
      return false;
    }

    if (startChanged() || currentChangeExceedsDrift()) {
      _controller.dispose();
      _controller = _createController();
    }
  }

  AnimationController _createController() {
    return AnimationController(vsync: this)
      ..duration = widget.start.seconds
      ..value = widget.current / widget.start
      ..addListener(() => setState(() {}))
      ..reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_controller.value, _controllerCurrent);
  }
}
