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
  static const _visibilityThreshold = 320;

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
          'back-to-top fixed right-5 bottom-5 z-20 inline-flex size-13 items-center justify-center border border-gold bg-navy text-highlight shadow-[5px_5px_0_color-mix(in_srgb,var(--color-navy)_24%,transparent)] transition-[background-color,border-color,color,opacity,transform,visibility] duration-200 hover:border-navy hover:bg-gold hover:text-navy focus-visible:outline-ready focus-visible:outline-offset-[5px] ${_visible ? 'visible translate-y-0 opacity-100 pointer-events-auto' : 'invisible translate-y-3 opacity-0 pointer-events-none'}',
      attributes: {
        'aria-label': 'Back to top',
        'aria-hidden': _visible ? 'false' : 'true',
        if (!_visible) 'tabindex': '-1',
      },
      [
        svg(
          viewBox: '0 -960 960 960',
          width: Unit.pixels(24),
          height: Unit.pixels(24),
          classes: 'fill-current',
          attributes: const {'aria-hidden': 'true'},
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
