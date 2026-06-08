import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../data/footer_links.dart';
import '../data/site_info.dart';

class Footer extends StatelessComponent {
  const Footer({super.key});

  @override
  Component build(BuildContext context) {
    return footer(classes: 'w-full flex flex-col text-lg tracking-wide px-4 sm:px-0 pt-6 pb-4 gap-4', [
      div(classes: 'flex flex-row self-center', [
        for (var i = 0; i < footerLinks.length; i++) ...[
          div(classes: 'flex flex-col font-light text-sm items-center', [
            .text(footerLinks[i].title),
            a(
              href: footerLinks[i].url,
              classes: 'underline',
              [.text(footerLinks[i].urlDisplay)],
            ),
          ]),
          if (i < footerLinks.length - 1) div(classes: 'bg-gray-300 w-[1px] min-h-full mx-4', []),
        ],
      ]),
      div(classes: 'w-full', [
        span(classes: 'block text-center text-gray-800 text-sm font-light', [
          .text(siteInfo.copyright),
        ]),
      ]),
    ]);
  }
}
