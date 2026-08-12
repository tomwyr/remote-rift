import 'dart:async';

import 'package:flutter/material.dart';

class const DelayedDisplay({
  super.key,
  required final Duration delay,
  final Widget placeholder = const SizedBox.shrink(),
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<DelayedDisplay> createState() => _DelayedDisplayState();
}

class _DelayedDisplayState extends State<DelayedDisplay> {
  var _isDelayOver = false;

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _startDelay() async {
    await Future.delayed(widget.delay);
    if (mounted) {
      setState(() => _isDelayOver = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isDelayOver ? widget.child : widget.placeholder;
  }
}
