import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/footer_links.dart';
import '../data/site_info.dart';

class Footer extends StatelessComponent {
  const Footer({super.key});

  @override
  Component build(
    BuildContext context,
  ) => footer(classes: 'bg-[#07101f] px-6 py-10 text-center text-[.85rem] text-[#d9d1c2]', [
    div(classes: 'flex flex-wrap justify-center gap-x-6 gap-y-3', [
      for (final link in footerLinks)
        a(
          href: link.url,
          classes:
              'font-extrabold text-highlight underline decoration-gold/70 underline-offset-4 transition-colors hover:text-gold focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-cyan',
          [
            .text(link.title),
          ],
        ),
    ]),
    p(classes: 'mx-auto my-4 max-w-[42rem]', [
      .text('Remote Rift is not affiliated with or endorsed by Riot Games or League of Legends.'),
    ]),
    small(classes: 'text-[#aeb6c0]', [.text(siteInfo.copyright)]),
  ]);
}
