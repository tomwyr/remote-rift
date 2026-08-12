import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';
import '../../widgets/layout.dart';

class const GameDataBody({
  super.key,
  final String? queueName,
  final Widget? queueNamePlaceholder,
  required final String title,
  required final String description,
  final Widget? child,
  final RiftStatusTone tone = .neutral,
  final IconData? icon,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var effectiveQueueName = queueName;
    // Use placeholder text only if no placeholder widget is provided.
    if (queueNamePlaceholder == null) {
      effectiveQueueName ??= t.gameQueue.unknownPlaceholder;
    }

    return Column(
      crossAxisAlignment: .start,
      spacing: 12,
      children: [
        BasicLayoutSection(
          label: t.home.gameModeLabel,
          title: effectiveQueueName,
          titlePlaceholder: queueNamePlaceholder,
        ),
        BasicLayoutSection(
          label: t.home.gameStateLabel,
          title: title,
          titleFontSize: .large,
          description: description,
          tone: tone,
          icon: icon,
        ),
        ?child,
      ],
    );
  }
}
