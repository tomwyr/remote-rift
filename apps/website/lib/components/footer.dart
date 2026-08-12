import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/footer_links.dart';
import '../data/site_info.dart';

class const Footer({super.key}) extends StatelessComponent {
  @override
  Component build(
    BuildContext context,
  ) => footer(classes: 'bg-footer px-6 py-10 text-center text-[.85rem] text-on-footer', [
    div(classes: 'flex flex-wrap justify-center gap-x-6 gap-y-3', [
      for (final link in footerLinks)
        a(
          href: link.url,
          classes: 'font-extrabold text-highlight underline decoration-gold/70 underline-offset-4 transition-colors hover:text-gold focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-cyan',
          [
            .text(link.title),
          ],
        ),
    ]),
    p(classes: 'mx-auto my-4 max-w-[42rem]', [
      .text('Remote Rift is not affiliated with or endorsed by Riot Games or League of Legends.'),
    ]),
    small(classes: 'text-on-footer-muted', [.text(siteInfo.copyright)]),
  ]);
}
