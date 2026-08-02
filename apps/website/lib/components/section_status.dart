import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/content.dart';

class SectionStatus extends StatelessComponent {
  const SectionStatus({super.key});

  @override
  Component build(
    BuildContext context,
  ) => section(id: 'status', classes: 'mx-auto max-w-304 px-6 py-24 max-[540px]:py-16', [
    div(classes: 'max-w-[43rem] border-l-[3px] border-gold pl-5', [
      span(
        classes: 'mb-[.9rem] block text-[.75rem] font-extrabold tracking-[.16em] text-gold-ink',
        [.text('CONNECTION ISSUES')],
      ),
      h2(
        classes:
            'font-serif text-[clamp(2.25rem,4vw,3.7rem)] font-bold leading-[1.06] tracking-[-.035em]',
        [.text('When Remote Rift cannot connect')],
      ),
      p(classes: 'mb-0 text-[1.08rem]', [
        .text(
          'Use the message in Remote Rift Mobile to check the desktop connection, app version, or local network.',
        ),
      ]),
    ]),
    div(classes: 'mt-10 grid grid-cols-3 gap-4 max-[800px]:grid-cols-2 max-[540px]:grid-cols-1', [
      for (final item in exceptionStates)
        article(classes: 'border-l-2 border-gold bg-transparent p-4', [
          span(
            classes: 'inline-flex size-[1.2rem] items-center justify-center font-black text-ready',
            [.text('!')],
          ),
          h3(classes: 'my-1 font-serif text-[1.35rem]', [.text(item.title)]),
          p(classes: 'm-0 text-[.9rem]', [.text(item.description)]),
          if (item.advice != null)
            p(
              classes: 'mt-3 border-t border-gold/60 pt-3 text-[.9rem] font-semibold text-gold-ink',
              [.text(item.advice!)],
            ),
        ]),
    ]),
  ]);
}
