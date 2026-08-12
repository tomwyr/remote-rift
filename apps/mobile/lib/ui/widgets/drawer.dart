import 'package:flutter/material.dart';

class const EndDrawerIcon({
  super.key,
  required final IconData icon,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: Scaffold.of(context).openEndDrawer, icon: Icon(icon));
  }
}
