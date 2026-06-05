import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart';

@client
class BackToTop extends StatefulComponent {
  const BackToTop({super.key});

  @override
  State<BackToTop> createState() => BackToTopState();
}

class BackToTopState extends State<BackToTop> {
  static const _visibilityThreshold = 720;

  bool _visible = false;
  StreamSubscription<Event>? _scrollSubscription;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _updateVisibility();
      _scrollSubscription = EventStreamProviders.scrollEvent.forTarget(window).listen((_) {
        _updateVisibility();
      });
    }
  }

  @override
  void dispose() {
    _scrollSubscription?.cancel();
    super.dispose();
  }

  void _updateVisibility() {
    final shouldBeVisible = window.scrollY >= _visibilityThreshold;

    if (_visible == shouldBeVisible) {
      return;
    }

    setState(() => _visible = shouldBeVisible);
  }

  @override
  Component build(BuildContext context) {
    return a(
      id: 'home-button',
      href: '#top',
      classes:
          '${_visible ? '' : 'hidden '}interactive-transition fixed bottom-0 right-0 mb-4 mr-4 text-gray-200 border rounded-full border-brand-600 hover:bg-white hover:text-brand-600 hover:border-brand-600 no-underline w-12 h-12 flex items-center justify-center bg-brand-600 shadow-md hover:shadow-lg',
      [
        svg(
          viewBox: '0 -960 960 960',
          width: Unit.pixels(24),
          height: Unit.pixels(24),
          classes: 'fill-current',
          [
            path(
              d: 'M480-528 296-344l-56-56 240-240 240 240-56 56-184-184Z',
              [],
            ),
          ],
        ),
      ],
    );
  }
}
