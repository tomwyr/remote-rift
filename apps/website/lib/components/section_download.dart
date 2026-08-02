import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/content.dart';
import '../data/downloads.dart';

class SectionDownload extends StatelessComponent {
  const SectionDownload({super.key});

  @override
  Component build(BuildContext context) => section(
    id: 'install',
    classes:
        'relative bg-navy px-[max(1.5rem,calc((100vw-76rem)/2+1.5rem))] py-24 text-highlight before:absolute before:inset-0 before:bg-[radial-gradient(17rem_circle_at_var(--cursor-x)_var(--cursor-y),color-mix(in_srgb,var(--color-light-blue)_5%,transparent),transparent_68%)] before:bg-fixed before:content-[\'\'] [&>*]:relative [&>*]:z-10 max-[540px]:py-16',
    [
      div(classes: 'mb-11 max-w-[43rem] border-l-[3px] border-gold pl-5', [
        span(classes: 'mb-[.9rem] block text-[.75rem] font-extrabold tracking-[.16em] text-gold', [
          .text('GET STARTED'),
        ]),
        h2(
          classes:
              'font-serif text-[clamp(2.25rem,4vw,3.7rem)] font-bold leading-[1.06] tracking-[-.035em]',
          [
            .text('Install Remote Rift'),
          ],
        ),
        p(classes: 'mb-0 text-[1.08rem]', [
          .text('Install the desktop and mobile applications before using Remote Rift.'),
        ]),
      ]),
      ol(
        classes: 'mb-8 grid grid-cols-5 gap-3 p-0 max-[800px]:grid-cols-2 max-[540px]:grid-cols-1',
        [
          for (final step in [
            'Install Remote Rift Desktop.',
            'Run the desktop application.',
            'Start the League Client.',
            'Install and open Remote Rift Mobile.',
            'Connect both devices to the same local network.',
          ])
            li(classes: 'border-t border-gold bg-panel-muted p-4 text-[.9rem]', [.text(step)]),
        ],
      ),
      p(
        classes:
            'my-8 flex max-w-[43rem] items-start gap-[.6rem] border-l-2 border-cyan bg-panel/60 px-4 py-3 text-[.9rem] text-[#d8e4ee]',
        [
          span(
            classes:
                'inline-flex size-[1.2rem] shrink-0 items-center justify-center font-black text-ready',
            [
              .text('◇'),
            ],
          ),
          .text(requirements),
        ],
      ),
      div(classes: 'mt-10 grid grid-cols-2 gap-4 max-[540px]:grid-cols-1', [
        for (final download in downloads)
          article(
            classes:
                'border border-gold bg-panel p-6 shadow-[6px_6px_0_color-mix(in_srgb,var(--color-rift-blue)_34%,transparent)]',
            [
              h3(classes: 'my-3 font-serif text-[1.35rem]', [.text(download.title)]),
              p(classes: 'mb-5 text-[#c8d0d9]', [.text(download.description)]),
              div(classes: 'grid grid-cols-2 gap-[.6rem]', [
                for (final link in download.links)
                  button(
                    classes:
                        'flex min-h-[4.3rem] flex-col justify-center gap-2 border border-gold/70 bg-navy px-4 py-3 text-left text-[.82rem] font-extrabold text-highlight opacity-100',
                    disabled: true,
                    [
                      span([.text(link.label!)]),
                      small(
                        classes:
                            'w-fit bg-gold px-2 py-[.15rem] text-[.65rem] font-extrabold uppercase tracking-[.08em] text-navy',
                        [.text('Coming soon')],
                      ),
                    ],
                  ),
              ]),
            ],
          ),
      ]),
    ],
  );
}
