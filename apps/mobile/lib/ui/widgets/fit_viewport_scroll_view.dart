import 'package:flutter/material.dart';

class const FitViewportScrollView({
  super.key,
  final ScrollController? controller,
  final EdgeInsets? padding,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final paddingHeight = padding?.vertical ?? 0;
        final contentHeight = constraints.maxHeight > paddingHeight
            ? constraints.maxHeight - paddingHeight
            : 0.0;

        return SingleChildScrollView(
          controller: controller,
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: contentHeight),
            child: child,
          ),
        );
      },
    );
  }
}
