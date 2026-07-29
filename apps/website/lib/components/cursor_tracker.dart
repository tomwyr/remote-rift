import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart';

@client
class CursorTracker extends StatefulComponent {
  const CursorTracker({super.key});

  @override
  State<CursorTracker> createState() => _CursorTrackerState();
}

class _CursorTrackerState extends State<CursorTracker> {
  StreamSubscription<MouseEvent>? _pointerSubscription;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _pointerSubscription = EventStreamProvider<MouseEvent>('pointermove').forTarget(document).listen(_trackPointer);
    }
  }

  @override
  void dispose() {
    _pointerSubscription?.cancel();
    super.dispose();
  }

  void _trackPointer(MouseEvent pointer) {
    final root = document.documentElement as HTMLElement?;
    root?.style.setProperty('--cursor-x', '${pointer.clientX}px');
    root?.style.setProperty('--cursor-y', '${pointer.clientY}px');
  }

  @override
  Component build(BuildContext context) => div(
    classes: 'cursor-tracker',
    attributes: const {'aria-hidden': 'true'},
    [],
  );
}
