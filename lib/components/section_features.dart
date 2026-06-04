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
      classes:
          'w-full min-h-screen flex flex-col justify-between items-center bg-brand-charcoal-500 py-16 px-4 md:px-8',
      [
        // Section header
        div(classes: 'text-center max-w-2xl mb-12', [
          h2(classes: 'text-3xl md:text-4xl font-bold mb-4 text-white', [
            .text(siteContent.featuresTitle),
          ]),
          p(classes: 'text-lg text-gray-300', [
            .text(siteContent.featuresContent),
          ]),
        ]),
        // Features grid
        div(classes: 'grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl w-full', [
          for (var feature in features)
            div(
              classes: 'bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow duration-300',
              [
                div(classes: 'flex items-start space-x-4', [
                  // Feature icon
                  div(classes: 'flex-shrink-0', [
                    img(src: '/images/${feature.icon}', alt: feature.title, classes: 'w-12 h-12'),
                  ]),
                  // Feature content
                  div(classes: 'flex-grow', [
                    h3(classes: 'text-xl font-semibold mb-2 text-gray-800', [
                      .text(feature.title),
                    ]),
                    p(classes: 'text-gray-600', [
                      .text(feature.content),
                    ]),
                  ]),
                ]),
              ],
            ),
        ]),
        // CTA Button
        div(classes: 'mt-12', [
          a(
            href: '#${siteContent.sectionIdDownload}',
            classes:
                'inline-block bg-brand-500 hover:bg-brand-600 text-white font-semibold py-3 px-8 rounded-lg transition-colors duration-300',
            [.text(siteContent.buttonDownloadNow)],
          ),
        ]),
      ],
    );
  }
}
