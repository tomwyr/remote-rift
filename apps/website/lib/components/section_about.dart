import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'navbar.dart';

class SectionAbout extends StatelessComponent {
  const SectionAbout({super.key});

  @override
  Component build(BuildContext context) => header(
    id: 'overview',
    classes:
        'site-hero min-h-screen min-h-[100svh] border-b border-gold/70 bg-[linear-gradient(90deg,transparent_0,transparent_calc(100%-1px),color-mix(in_srgb,var(--color-rift-blue)_5%,transparent)_calc(100%-1px)),linear-gradient(0deg,transparent_0,transparent_calc(100%-1px),color-mix(in_srgb,var(--color-rift-blue)_3%,transparent)_calc(100%-1px))] bg-[size:8rem_8rem]',
    [
      const Navbar(),
      div(
        classes:
            'mx-auto grid min-h-[calc(100svh-5rem)] max-w-304 grid-cols-[minmax(0,1fr)_minmax(22rem,.9fr)] items-center gap-16 px-6 py-12 max-[800px]:min-h-0 max-[800px]:grid-cols-1 max-[800px]:gap-10 landscape:max-[800px]:grid-cols-[minmax(0,1fr)_auto] landscape:max-[800px]:gap-6 landscape:max-[800px]:py-8',
        [
          div([
            span(
              classes: 'mb-[.9rem] block text-[.75rem] font-extrabold tracking-[.16em] text-gold',
              [
                .text('LOCAL LEAGUE COMPANION'),
              ],
            ),
            h1(
              classes:
                  'max-w-[11ch] font-serif text-[4rem] font-bold leading-[1.06] tracking-[-.035em] max-[1200px]:text-[3.25rem] max-[900px]:max-w-full max-[900px]:text-[2.5rem] max-[900px]:leading-[1.1] max-[900px]:[overflow-wrap:anywhere] max-[480px]:text-[2rem]',
              [.text('Manage League matchmaking from your phone')],
            ),
            p(classes: 'my-6 max-w-[39rem] text-[1.15rem]', [
              .text(
                'Use your phone to check queue and lobby status, manage supported matchmaking actions, and respond when a match is found.',
              ),
            ]),
            div(
              classes: 'mt-8 flex w-full flex-wrap gap-3',
              [
                a(
                  href: '#how-it-works',
                  classes:
                      'max-[480px]:flex-1 border border-gold bg-navy px-[1.1rem] py-[.8rem] text-center text-[.9rem] font-bold tracking-[.04em] text-highlight no-underline transition-colors duration-200 hover:border-navy hover:bg-gold hover:text-navy',
                  [.text('How it works')],
                ),
                a(
                  href: '#install',
                  classes:
                      'max-[480px]:flex-1 border border-navy px-[1.1rem] py-[.8rem] text-center text-[.9rem] font-bold tracking-[.04em] no-underline transition-colors duration-200 hover:border-cyan hover:bg-cyan hover:text-navy',
                  [.text('Downloads')],
                ),
              ],
            ),
          ]),
          figure(
            classes:
                'm-0 flex w-fit max-w-full justify-self-center flex-col items-center gap-4 landscape:max-[800px]:gap-2',
            [
              div(
                classes:
                    'rounded-[clamp(1.75rem,6.3svh,3.15rem)] border-[clamp(.25rem,.9svh,.45rem)] border-[#1b1e24] bg-[#1b1e24] p-[clamp(.1rem,.36svh,.18rem)] shadow-[clamp(6px,1.5svh,12px)_clamp(6px,1.5svh,12px)_0_color-mix(in_srgb,var(--color-navy)_16%,transparent)] landscape:max-[1000px]:rounded-[clamp(1.75rem,6.3vw,3.15rem)] landscape:max-[1000px]:border-[clamp(.25rem,.9vw,.45rem)] landscape:max-[1000px]:p-[clamp(.1rem,.36vw,.18rem)] landscape:max-[1000px]:shadow-[clamp(6px,1.5vw,12px)_clamp(6px,1.5vw,12px)_0_color-mix(in_srgb,var(--color-navy)_16%,transparent)]',
                [
                  div(
                    classes:
                        'h-[min(42rem,55vw)] aspect-[1206/2622] overflow-hidden rounded-[clamp(1.47rem,5.3svh,2.65rem)] bg-canvas max-[800px]:h-[min(36rem,74svh)] landscape:max-[800px]:h-[min(42rem,55vw)] landscape:max-[1000px]:rounded-[clamp(1.47rem,5.3vw,2.65rem)] min-[1001px]:h-[min(40rem,53vw)]',
                    [
                      img(
                        src: 'images/showcase/showcase.png',
                        alt: 'Remote Rift Mobile showing a game found ready-check countdown',
                        classes: 'block h-full w-full object-cover',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
