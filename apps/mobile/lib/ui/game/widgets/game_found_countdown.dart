import 'dart:math';

import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../../i18n/strings.g.dart';
import '../../widgets/time_countdown.dart';

class const GameFoundCountdown({
  super.key,
  required final double maxTime,
  required final double timeLeft,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Reduce time left slightly to account for the async communication delay
    // to better align the countdown with the game UI.
    final effectiveTimeLeft = max(timeLeft - 0.1, 0.0);

    final colors = context.remoteRiftTheme.colorScheme;

    return TimeCountdown(
      start: maxTime,
      current: effectiveTimeLeft,
      drift: 1.5,
      builder: (progress, seconds) => Container(
        width: .infinity,
        margin: const .only(top: 4),
        padding: const .symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colors.ready.withValues(alpha: 0.06),
          border: .all(color: colors.cyan),
        ),
        child: Column(
          children: [
            Text(
              t.gameState.foundPendingTimeLeft.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontWeight: .w800, letterSpacing: 1.2),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 92,
              height: 92,
              child: Stack(
                fit: .expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 7,
                    backgroundColor: colors.gold.withValues(alpha: 0.25),
                    color: colors.ready,
                  ),
                  Center(
                    child: Text(
                      '${seconds.ceil()}',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
