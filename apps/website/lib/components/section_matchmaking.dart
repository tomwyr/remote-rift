import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/content.dart';

class SectionMatchmaking extends StatelessComponent {
  const SectionMatchmaking({super.key});

  @override
  Component build(BuildContext context) => section(
    id: 'features',
    classes:
        'relative mx-auto max-w-none bg-navy px-[max(1.5rem,calc((100vw-76rem)/2+1.5rem))] py-24 text-highlight before:absolute before:inset-0 before:bg-[radial-gradient(17rem_circle_at_var(--cursor-x)_var(--cursor-y),color-mix(in_srgb,var(--color-light-blue)_5%,transparent),transparent_68%),linear-gradient(90deg,color-mix(in_srgb,var(--color-cyan)_8%,transparent),transparent_28%)] before:bg-fixed before:content-[\'\'] [&>*]:relative [&>*]:z-10 max-[540px]:py-16',
    [
      div(classes: 'mb-11 max-w-[43rem] border-l-[3px] border-gold pl-5', [
        span(classes: 'mb-[.9rem] block text-[.75rem] font-extrabold tracking-[.16em] text-gold', [
          .text('REMOTE CONTROLS'),
        ]),
        h2(classes: 'font-serif text-[clamp(2.25rem,4vw,3.7rem)] font-bold leading-[1.06] tracking-[-.035em]', [
          .text('Manage matchmaking from your phone'),
        ]),
        p(classes: 'mb-0 text-[1.08rem]', [
          .text('Available controls follow the current League Client state.'),
        ]),
      ]),
      div(classes: 'grid grid-cols-[minmax(17rem,.8fr)_1fr] gap-12 max-[800px]:grid-cols-1 max-[800px]:gap-10', [
        div(
          classes:
              'border border-gold bg-panel p-6 shadow-[6px_6px_0_color-mix(in_srgb,var(--color-rift-blue)_34%,transparent)]',
          [
              h3(classes: 'my-3 font-serif text-[1.35rem]', [.text('Matchmaking controls')]),
            ul(classes: 'grid list-none grid-cols-2 gap-x-4 gap-y-[.55rem] p-0 max-[540px]:grid-cols-1', [
              for (final action in matchmakingActions)
                li(classes: "before:mr-2 before:text-cyan before:content-['◇']", [.text(action)]),
            ]),
          ],
        ),
        div(classes: 'pt-4 text-[1.1rem]', [
            h3(classes: 'my-3 font-serif text-[1.35rem]', [.text('Supported queues')]),
            p(classes: 'mb-4', [.text('Choose from the queues currently available in the League Client.')]),
            div(classes: 'flex flex-wrap gap-2', [
            for (final group in queueGroups)
              span(classes: 'border border-cyan/60 px-[.6rem] py-[.4rem] text-[.84rem]', [.text(group)]),
          ]),
        ]),
      ]),
    ],
  );
}
