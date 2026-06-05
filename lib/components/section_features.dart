import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../data/content.dart';
import '../data/features.dart';

class SectionFeatures extends StatelessComponent {
  const SectionFeatures({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      id: siteContent.sectionIdFeatures,
      classes: 'w-full min-h-screen flex flex-col justify-between items-center bg-brand-charcoal-500',
      [
        div([]),
        div(classes: 'flex flex-col items-center my-12', [
          div(classes: 'self-center text-center w-full sm:w-2/3 xl:w-1/2 px-4 sm:px-0', [
            h2(classes: 'tracking-wide text-gray-200 font-bold text-4xl mb-4', [
              .text(siteContent.featuresTitle),
            ]),
            p(classes: 'font-light text-gray-200 text-xl mb-6', [
              .text(siteContent.featuresContent),
            ]),
          ]),
          div(
            classes: 'self-center w-full xl:w-4/5 max-w-[1280px] flex flex-col sm:flex-row flex-wrap px-4 xl:px-0',
            [
              for (var feature in features)
                div(
                  classes:
                      'interactive-transition w-full sm:w-1/2 flex flex-row flex-no-wrap justify-start gap-4 rounded-xl hover:shadow-lg hover:bg-brand-charcoal-600 hover:bg-opacity-50 px-4 sm:px-8 py-6 sm:py-12',
                  [
                    img(src: '/images/${feature.icon}', alt: feature.title, classes: 'w-12 h-12 self-start'),
                    div(classes: 'flex flex-col', [
                      h3(classes: 'tracking-wide text-gray-200 font-bold text-2xl mb-2', [
                        .text(feature.title),
                      ]),
                      p(classes: 'font-light text-gray-200 text-lg', [
                        .text(feature.content),
                      ]),
                    ]),
                  ],
                ),
            ],
          ),
        ]),
        div(classes: 'flex flex-row w-full justify-center pb-12', [
          a(
            href: '#${siteContent.sectionIdDownload}',
            classes:
                'interactive-transition px-10 py-2 text-white hover:text-brand-600 bg-brand-600 hover:bg-gray-200 border border-brand-600 rounded-full shadow-md text-lg',
            [.text(siteContent.buttonDownloadNow)],
          ),
        ]),
      ],
    );
  }
}
