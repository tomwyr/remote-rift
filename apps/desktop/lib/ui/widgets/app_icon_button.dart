import 'package:flutter/material.dart';

class const AppIconButton({
  super.key,
  final String? tooltip,
  required final IconData icon,
  required final VoidCallback onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        minimumSize: const Size(40, 40),
        maximumSize: const Size(40, 40),
        padding: const .all(10),
        tapTargetSize: .shrinkWrap,
      ),
      onPressed: onPressed,
    );
  }
}
