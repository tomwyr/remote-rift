import 'package:flutter/material.dart';

class const AppSwitch({
  required final bool value,
  required final ValueChanged<bool> onChanged,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 36,
      child: FittedBox(
        fit: .contain,
        child: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
