import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../data/content.dart';
import '../data/downloads.dart';

class SectionDownload extends StatelessComponent {
  const SectionDownload({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      id: siteContent.sectionIdDownload,
      classes: 'w-full min-h-screen flex flex-col justify-center items-center bg-gray-800 py-16 px-4 md:px-8 lg:px-12',
      [
        // Section header
        div(classes: 'text-center max-w-2xl mb-12', [
          h2(classes: 'text-3xl md:text-4xl font-bold mb-4 text-white', [
            .text(siteContent.downloadTitle),
          ]),
          p(classes: 'text-lg text-gray-300', [
            .text(siteContent.downloadContent),
          ]),
        ]),
        // Download cards
        div(classes: 'grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl w-full', [
          for (var download in downloads)
            div(
              classes: 'bg-gray-700 rounded-lg shadow-lg p-8 hover:shadow-xl transition-shadow duration-300',
              [
                // Download title and description
                h3(classes: 'text-2xl font-semibold mb-4 text-white', [
                  .text(download.title),
                ]),
                p(classes: 'text-gray-300 mb-6', [
                  .text(download.description),
                ]),
                // Download links
                div(classes: 'flex flex-wrap gap-4', [
                  for (var link in download.links)
                    if (link.icon != null)
                      // Icon link (app store, play store)
                      div(classes: 'relative group', [
                        a(
                          href: '#', // Placeholder URL
                          classes: 'inline-block opacity-100 hover:opacity-80 transition-opacity',
                          [
                            img(
                              src: '/images/${link.icon}',
                              alt: download.title,
                              classes: 'h-12 w-auto',
                            ),
                          ],
                        ),
                      ])
                    else if (link.label != null)
                      // Label link (Windows, macOS) with "Coming soon" badge
                      div(classes: 'relative inline-block', [
                        button(
                          classes: 'bg-gray-600 text-gray-400 font-semibold py-2 px-6 rounded cursor-not-allowed',
                          [
                            .text(link.label!),
                          ],
                        ),
                        div(
                          classes: 'absolute -top-2 -right-2 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded',
                          [.text('Coming soon')],
                        ),
                      ]),
                ]),
              ],
            ),
        ]),
      ],
    );
  }
}
