import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../data/content.dart';
import '../data/site_info.dart';

class SectionAbout extends StatelessComponent {
  const SectionAbout({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      id: siteContent.sectionIdAbout,
      classes: 'w-full min-h-screen flex flex-col justify-between',
      [
        div(classes: 'flex flex-col items-center justify-center flex-grow', [
          // Logo
          div(classes: 'mb-8', [
            img(src: '/images/logo.png', alt: siteInfo.title, classes: 'h-20 w-auto'),
          ]),
          // Title and content
          div(classes: 'text-center max-w-2xl px-4', [
            h1(classes: 'text-4xl md:text-5xl font-bold mb-6', [
              .text(siteContent.aboutTitle),
            ]),
            p(classes: 'text-lg text-gray-700 mb-8', [
              .text(siteContent.aboutContent),
            ]),
            // CTA Button
            a(
              href: '#${siteContent.sectionIdDownload}',
              classes:
                  'inline-block bg-brand-500 hover:bg-brand-600 text-white font-semibold py-3 px-8 rounded-lg transition-colors duration-300',
              [.text(siteContent.buttonMoreInformation)],
            ),
          ]),
        ]),
        // Showcase image at bottom
        div(classes: 'flex justify-center pb-12', [
          img(src: '/images/showcase.png', alt: 'Remote Rift Showcase', classes: 'max-w-full h-auto'),
        ]),
      ],
    );
  }
}
