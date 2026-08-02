import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'navbar.dart';

class SectionAbout extends StatelessComponent {
  const SectionAbout({super.key});

  @override
  Component build(BuildContext context) => header(
    id: 'overview',
    classes:
        'min-h-screen border-b border-gold/70 bg-[linear-gradient(90deg,transparent_0,transparent_calc(100%-1px),color-mix(in_srgb,var(--color-rift-blue)_5%,transparent)_calc(100%-1px)),linear-gradient(0deg,transparent_0,transparent_calc(100%-1px),color-mix(in_srgb,var(--color-rift-blue)_3%,transparent)_calc(100%-1px))] bg-[size:8rem_8rem]',
    [
      const Navbar(),
      div(
        classes:
            'mx-auto grid min-h-[calc(100vh-5rem)] max-w-304 grid-cols-[minmax(0,1fr)_minmax(22rem,.9fr)] items-center gap-16 px-6 py-12 max-[800px]:min-h-0 max-[800px]:grid-cols-1 max-[800px]:gap-10',
        [
          div([
            span(
              classes:
                  'mb-[.9rem] block text-[.75rem] font-extrabold tracking-[.16em] text-gold-ink',
              [
                .text('LOCAL LEAGUE COMPANION'),
              ],
            ),
            h1(
              classes:
                  'max-w-[11ch] font-serif text-[clamp(3rem,6vw,5.6rem)] font-bold leading-[1.06] tracking-[-.035em] max-[800px]:max-w-[12ch]',
              [.text('Manage League matchmaking from your phone')],
            ),
            p(classes: 'my-6 max-w-[39rem] text-[1.15rem]', [
              .text(
                'Use your phone to check queue and lobby status, manage supported matchmaking actions, and respond when a match is found.',
              ),
            ]),
            div(
              classes: 'mt-8 flex flex-wrap gap-3',
              [
                a(
                  href: '#how-it-works',
                  classes:
                      'border border-gold bg-navy px-[1.1rem] py-[.8rem] text-[.9rem] font-extrabold tracking-[.04em] text-highlight no-underline transition-colors duration-200 hover:border-navy hover:bg-gold hover:text-navy',
                  [.text('How it works')],
                ),
                a(
                  href: '#install',
                  classes:
                      'border border-navy px-[1.1rem] py-[.8rem] text-[.9rem] font-extrabold tracking-[.04em] no-underline transition-colors duration-200 hover:border-cyan hover:bg-cyan hover:text-navy',
                  [.text('Downloads')],
                ),
              ],
            ),
          ]),
          figure(
            classes:
                'm-0 border border-gold bg-panel p-3 shadow-[12px_12px_0_color-mix(in_srgb,var(--color-navy)_16%,transparent)]',
            [
              img(
                src: 'images/showcase/showcase.png',
                alt: 'Example Remote Rift ready-check screen showing a game found state',
              ),
              figcaption(classes: 'px-1 pt-3 text-[.8rem] tracking-[.05em] text-highlight', [
                .text('Respond to a found match from your phone.'),
              ]),
            ],
          ),
        ],
      ),
    ],
  );
}
