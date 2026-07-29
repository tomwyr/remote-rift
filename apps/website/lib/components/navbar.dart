import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_info.dart';

class Navbar extends StatelessComponent {
  const Navbar({super.key});

  @override
  Component build(BuildContext context) => nav(
    classes:
        'mx-auto flex max-w-304 items-center justify-between gap-4 px-6 py-[1.2rem] max-[800px]:flex-col max-[800px]:items-start',
    [
      a(href: '#top', classes: 'inline-flex items-center gap-[.6rem] font-bold tracking-[.06em] no-underline', [
        img(src: 'images/branding/logo.png', alt: '', classes: 'size-9 object-contain'),
        span([.text(siteInfo.title)]),
      ]),
      div(
        classes:
            'flex items-center gap-5 text-[.82rem] font-bold tracking-[.06em] max-[800px]:w-full max-[800px]:flex-wrap max-[800px]:gap-x-4 max-[800px]:gap-y-3 max-[540px]:text-[.75rem]',
        [
          a(
            href: '#how-it-works',
            classes: 'hover:text-gold-ink hover:underline hover:decoration-2 hover:underline-offset-4',
            [.text('How it works')],
          ),
          a(
            href: '#features',
            classes: 'hover:text-gold-ink hover:underline hover:decoration-2 hover:underline-offset-4',
            [.text('Features')],
          ),
          a(
            href: '#status',
            classes: 'hover:text-gold-ink hover:underline hover:decoration-2 hover:underline-offset-4',
            [.text('Troubleshooting')],
          ),
          a(
            href: '#install',
            classes:
                'border border-gold bg-navy px-[.85rem] py-[.55rem] text-highlight transition-colors duration-200 hover:border-navy hover:bg-gold hover:text-navy',
            [.text('Install')],
          ),
        ],
      ),
    ],
  );
}
