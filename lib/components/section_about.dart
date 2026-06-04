import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../data/content.dart';

class SectionAbout extends StatelessComponent {
  const SectionAbout({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      id: siteContent.sectionIdAbout,
      classes: 'w-full min-h-screen flex flex-col justify-between',
      [
        div(classes: 'flex flex-col justify-center h-full py-12', [
          div(classes: 'self-center text-center w-full sm:w-2/3 xl:w-1/2 px-4 sm:px-0', [
            h2(classes: 'font-bold tracking-wider text-gray-800 text-4xl mb-4', [
              .text(siteContent.aboutTitle),
            ]),
            p(classes: 'font-light text-black text-xl', [
              .text(siteContent.aboutContent),
            ]),
            img(
              classes: 'my-12 max-h-64 max-w-full mx-auto',
              src: '/images/showcase.png',
              alt: 'Remote Rift',
            ),
          ]),
        ]),
        div(classes: 'flex flex-row w-full justify-center pb-12', [
          a(
            href: '#${siteContent.sectionIdFeatures}',
            classes:
                'px-10 py-2 text-white hover:text-brand-600 bg-brand-600 hover:bg-white border border-brand-600 rounded-full shadow-md text-lg',
            [.text(siteContent.buttonMoreInformation)],
          ),
        ]),
      ],
    );
  }
}
