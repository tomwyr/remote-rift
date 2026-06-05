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
          '${_visible ? '' : 'hidden '}fixed bottom-0 right-0 mb-4 mr-4 text-gray-200 border rounded-full border-brand-600 hover:bg-gray-200 hover:text-brand-600 hover:border-browngray no-underline w-12 h-12 flex items-center justify-center bg-brand-600 shadow-md',
      [
        // Arrow up icon
        span(classes: 'text-2xl', [.text('↑')]),
      ],
    );
  }
}
