import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_info.dart';

class Footer extends StatelessComponent {
  const Footer({super.key});

  @override
  Component build(BuildContext context) =>
      footer(classes: 'bg-[#07101f] px-6 py-10 text-center text-[.85rem] text-[#d9d1c2]', [
        a(href: 'https://github.com/tomwyr/remote-rift', classes: 'font-extrabold text-highlight', [
          .text('Source and technical information'),
        ]),
        p(classes: 'mx-auto my-4 max-w-[42rem]', [
          .text('Remote Rift is not affiliated with or endorsed by Riot Games or League of Legends.'),
        ]),
        small(classes: 'text-[#aeb6c0]', [.text(siteInfo.copyright)]),
      ]);
}
