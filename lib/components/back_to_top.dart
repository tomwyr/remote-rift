import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

@client
class BackToTop extends StatefulComponent {
  const BackToTop({super.key});

  @override
  State<BackToTop> createState() => BackToTopState();
}

class BackToTopState extends State<BackToTop> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // TODO: Add scroll listener in Phase 6
  }

  @override
  Component build(BuildContext context) {
    return a(
      id: 'home-button',
      href: '#top',
      classes:
          'fixed bottom-0 right-0 mb-4 mr-4 text-gray-200 border rounded-full border-brand-600 hover:bg-gray-200 hover:text-brand-600 hover:border-browngray no-underline w-12 h-12 flex items-center justify-center bg-brand-600 shadow-md',
      [
        // Arrow up icon
        span(classes: 'text-2xl', [.text('↑')]),
      ],
    );
  }
}
