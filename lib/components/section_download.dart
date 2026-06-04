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
      classes: 'w-full min-h-screen flex flex-col justify-center items-center bg-gray-800 pb-12 px-4 md:px-8 lg:px-12 gap-8 md:gap-12 lg:gap-16',
      [
        // Section header
        div(classes: 'self-center text-center w-full sm:w-2/3 xl:w-1/2 px-4 sm:px-0', [
          h2(classes: 'font-bold tracking-widest text-gray-100 text-4xl mb-4', [
            .text(siteContent.downloadTitle),
          ]),
          p(classes: 'font-light text-gray-300 text-xl', [
            .text(siteContent.downloadContent),
          ]),
        ]),
        // Download cards
        div(classes: 'flex flex-col sm:flex-row gap-4 md:gap-8 lg:gap-12 text-gray-100', [
          for (var download in downloads)
            div(
              classes: 'flex flex-col max-w-[420px] items-center p-4 md:p-8 lg:p-12 rounded-xl bg-gray-700/30 shadow-lg',
              [
                // Download title and description
                p(classes: 'font-bold text-2xl mb-2', [
                  .text(download.title),
                ]),
                p(classes: 'text-center mt-2 mb-6 text-gray-300', [
                  .text(download.description),
                ]),
                // Download links
                for (var link in download.links)
                  div(classes: 'relative inline-block mt-2', [
                    if (link.label != null)
                      // Label link (Windows, macOS) with "Coming soon" badge
                      div(
                        classes: 'flex flex-row w-40 px-4 py-2 my-1 bg-brand-600 border border-transparent hover:border-brand-500 rounded-full justify-center cursor-default opacity-50',
                        [
                          if (link.icon != null)
                            img(
                              src: '/images/${link.icon}',
                              alt: download.title,
                              classes: 'h-10 my-1 cursor-default opacity-50',
                            ),
                          if (link.label != null)
                            span(classes: '', [.text(link.label!)]),
                        ],
                      )
                    else if (link.icon != null)
                      // Icon link (app store, play store)
                      img(
                        src: '/images/${link.icon}',
                        alt: download.title,
                        classes: 'h-10 my-1 cursor-default opacity-50',
                      ),
                    // "Coming soon" badge
                    span(
                      classes: 'absolute -top-1 -right-2 text-[10px] bg-brand-600 text-white px-2 py-0.5 rounded-full shadow-md border border-white cursor-default',
                      [.text('Coming soon')],
                    ),
                  ]),
              ],
            ),
        ]),
      ],
    );
  }
}
