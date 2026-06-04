import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'components/navbar.dart';
import 'components/section_about.dart';
import 'components/section_features.dart';
import 'components/section_download.dart';
import 'components/footer.dart';
import 'components/back_to_top.dart';

// The main component of your application.
//
// Single-page landing page with smooth scrolling navigation.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return div([
      const Navbar(),
      const SectionAbout(),
      const SectionFeatures(),
      const SectionDownload(),
      const Footer(),
      const BackToTop(),
    ]);
  }
}
