import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/content.dart';

class const SectionMatchmaking({super.key}) extends StatelessComponent {
  @override
  Component build(BuildContext context) => section(
    id: 'features',
    classes: 'cursor-atmosphere cursor-atmosphere--cyan-wash relative mx-auto max-w-none bg-navy px-[max(1.5rem,calc((100vw-76rem)/2+1.5rem))] py-24 text-highlight [&>*]:relative [&>*]:z-10 max-[540px]:py-16',
    [
      div(classes: 'mb-11 max-w-[43rem] border-l-[3px] border-gold pl-5', [
        span(classes: 'mb-[.9rem] block text-[.75rem] font-extrabold tracking-[.16em] text-gold', [
          .text('REMOTE CONTROLS'),
        ]),
        h2(
          classes: 'font-serif text-[clamp(2.25rem,4vw,3.7rem)] font-bold leading-[1.06] tracking-[-.035em]',
          [
            .text('A focused solo draft loop from lobby to lock in'),
          ],
        ),
        p(classes: 'mb-0 text-[1.08rem]', [
          .text(
            'Remote Rift follows the live League Client state, showing only the actions available to you now.',
          ),
        ]),
      ]),
      div(
        classes: 'grid grid-cols-[minmax(17rem,.8fr)_1fr] gap-12 max-[800px]:grid-cols-1 max-[800px]:gap-10',
        [
          div(
            classes: 'border border-gold bg-panel p-6 shadow-[6px_6px_0_color-mix(in_srgb,var(--color-rift-blue)_34%,transparent)]',
            [
              for (final group in releasedCapabilities) ...[
                h3(classes: 'my-3 font-serif text-[1.35rem]', [.text(group.title)]),
                ul(classes: 'grid list-none grid-cols-1 gap-y-[.55rem] p-0', [
                  for (final capability in group.items)
                    li(classes: "before:mr-2 before:text-cyan before:content-['◇']", [
                      .text(capability),
                    ]),
                ]),
              ],
            ],
          ),
          div(classes: 'pt-4 text-[1.1rem]', [
            h3(classes: 'my-3 font-serif text-[1.35rem]', [.text('Scope of this release')]),
            p(classes: 'mb-4', [
              .text(
                'Remote Rift supports the individual player journey in supported solo draft queues.',
              ),
            ]),
            div(classes: 'border-l-2 border-cyan bg-panel/60 p-4 text-[.94rem]', [
              p(classes: 'mt-0 font-semibold text-highlight', [.text('Not included')]),
              ul(classes: 'm-0 list-none p-0', [
                for (final capability in deferredCapabilities)
                  li(classes: "before:mr-2 before:text-gold before:content-['—']", [
                    .text(capability),
                  ]),
              ]),
            ]),
          ]),
        ],
      ),
      div(classes: 'mt-12 grid grid-cols-3 gap-5 max-[800px]:grid-cols-1', [
        for (final screenshot in productScreenshots)
          figure(classes: 'm-0 flex flex-col gap-3', [
            div(classes: 'overflow-hidden border border-gold bg-panel p-2', [
              img(src: screenshot.path, alt: screenshot.alt, classes: 'block h-auto w-full'),
            ]),
            figcaption(classes: 'text-[.94rem] text-on-panel-muted', [.text(screenshot.caption)]),
          ]),
      ]),
    ],
  );
}
