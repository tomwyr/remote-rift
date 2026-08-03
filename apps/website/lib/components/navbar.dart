import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_info.dart';

@client
class Navbar extends StatefulComponent {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _menuOpen = false;

  @override
  Component build(BuildContext context) => nav(
    classes:
        'mx-auto flex max-w-304 items-center justify-between gap-4 px-6 py-[1.2rem] max-[800px]:relative max-[800px]:py-4',
    [
      a(
        href: '#top',
        classes: 'inline-flex items-center gap-[.6rem] font-bold tracking-[.06em] no-underline',
        [
          img(src: 'images/branding/logo.png', alt: '', classes: 'size-9 object-contain'),
          span(classes: 'font-medium', [.text(siteInfo.title)]),
        ],
      ),
      div(
        classes: 'group',
        [
          button(
            classes:
                'hidden size-11 cursor-pointer items-center justify-center border border-gold bg-navy text-highlight max-[800px]:flex',
            type: ButtonType.button,
            onClick: () => setState(() => _menuOpen = !_menuOpen),
            attributes: {'aria-label': 'Navigation menu', 'aria-expanded': '$_menuOpen'},
            [
              svg(
                viewBox: '0 0 24 24',
                width: Unit.pixels(24),
                height: Unit.pixels(24),
                classes: 'fill-none stroke-current stroke-2',
                attributes: const {'aria-hidden': 'true'},
                [
                  path(d: 'M4 7h16M4 12h16M4 17h16', []),
                ],
              ),
            ],
          ),
          div(
            classes:
                'flex items-center gap-5 text-[.82rem] font-semibold tracking-[.06em] max-[800px]:absolute max-[800px]:top-[calc(100%+.25rem)] max-[800px]:right-6 max-[800px]:w-[min(18rem,calc(100vw-3rem))] max-[800px]:flex-col max-[800px]:items-stretch max-[800px]:gap-1 max-[800px]:border max-[800px]:border-gold max-[800px]:bg-navy max-[800px]:p-2 max-[800px]:text-highlight max-[800px]:shadow-[6px_6px_0_color-mix(in_srgb,var(--color-rift-blue)_34%,transparent)] max-[800px]:-translate-y-2 max-[800px]:opacity-0 max-[800px]:pointer-events-none max-[800px]:transition-[opacity,translate] max-[800px]:duration-200 ${_menuOpen ? 'max-[800px]:translate-y-0 max-[800px]:opacity-100 max-[800px]:pointer-events-auto' : ''}',
            [
              a(
                href: '#how-it-works',
                classes:
                    'p-0 hover:text-gold-ink hover:underline hover:decoration-2 hover:underline-offset-4 max-[800px]:p-3',
                [.text('How it works')],
              ),
              a(
                href: '#features',
                classes:
                    'p-0 hover:text-gold-ink hover:underline hover:decoration-2 hover:underline-offset-4 max-[800px]:p-3',
                [.text('Features')],
              ),
              a(
                href: '#status',
                classes:
                    'p-0 hover:text-gold-ink hover:underline hover:decoration-2 hover:underline-offset-4 max-[800px]:p-3',
                [.text('Troubleshooting')],
              ),
              a(
                href: '#install',
                classes:
                    'border border-gold bg-navy px-[.85rem] py-[.55rem] text-highlight font-bold transition-colors duration-200 hover:border-navy hover:bg-gold hover:text-navy max-[800px]:p-3 max-[800px]:text-center',
                [.text('Install')],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
