import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/content.dart';

class SectionHowItWorks extends StatelessComponent {
  const SectionHowItWorks({super.key});

  @override
  Component build(
    BuildContext context,
  ) => section(id: 'how-it-works', classes: 'mx-auto max-w-304 px-6 py-24 max-[540px]:py-16', [
    div(classes: 'mb-11 max-w-[43rem] border-l-[3px] border-gold pl-5', [
      span(
        classes: 'mb-[.9rem] block text-[.75rem] font-extrabold tracking-[.16em] text-gold',
        [
          .text('LOCAL CONNECTION'),
        ],
      ),
      h2(
        classes:
            'font-serif text-[clamp(2.25rem,4vw,3.7rem)] font-bold leading-[1.06] tracking-[-.035em]',
        [
          .text('How the connection works'),
        ],
      ),
    ]),
    ol(
      classes:
          'grid grid-cols-4 gap-px border border-gold bg-gold p-0 max-[800px]:grid-cols-2 max-[540px]:grid-cols-1',
      [
        for (var i = 0; i < setupSteps.length; i++)
          li(
            classes:
                'min-h-52 bg-highlight p-6 shadow-[inset_0_3px_0_color-mix(in_srgb,var(--color-rift-blue)_36%,transparent)]',
            [
              span(classes: 'text-[.8rem] font-extrabold tracking-[.12em] text-gold-ink', [
                .text('0${i + 1}'),
              ]),
              h3(classes: 'my-3 min-h-[3rem] font-serif text-[1.35rem]', [
                .text(setupSteps[i].title),
              ]),
              p(classes: 'm-0', [.text(setupSteps[i].description)]),
            ],
          ),
      ],
    ),
    p(classes: 'mt-8 flex max-w-[58rem] gap-[.55rem] border border-gold p-4 text-[.94rem]', [
      span(
        classes:
            'inline-flex size-[1.2rem] shrink-0 items-center justify-center font-black text-ready',
        [
          .text('!'),
        ],
      ),
      .text(
        'If the connector cannot be found, confirm that both devices can communicate on the local network and that the desktop application is running.',
      ),
    ]),
  ]);
}
