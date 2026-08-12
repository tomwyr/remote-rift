import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'components/back_to_top.dart';
import 'components/cursor_tracker.dart';
import 'components/footer.dart';
import 'components/section_about.dart';
import 'components/section_download.dart';
import 'components/section_how_it_works.dart';
import 'components/section_matchmaking.dart';
import 'components/section_status.dart';

class const App({super.key}) extends StatelessComponent {
  @override
  Component build(BuildContext context) => div(
    id: 'top',
    classes: 'cursor-glow isolate min-h-screen bg-canvas [&>*:not(.back-to-top)]:relative [&>*:not(.back-to-top)]:z-10',
    [
      const CursorTracker(),
      const SectionAbout(),
      main_([
        const SectionHowItWorks(),
        const SectionMatchmaking(),
        const SectionStatus(),
        const SectionDownload(),
      ]),
      const Footer(),
      const BackToTop(),
    ],
  );
}
