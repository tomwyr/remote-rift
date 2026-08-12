import 'package:flutter/material.dart';

class const TextFieldSuffixButton({
  super.key,
  required final IconData icon,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(padding: const .all(4), child: Icon(icon)),
    );
  }
}
