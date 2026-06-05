import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../data/content.dart';
import '../data/site_info.dart';

@client
class Navbar extends StatefulComponent {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  bool _menuOpen = false;

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
  }

  void _closeMenu() {
    if (_menuOpen) {
      setState(() => _menuOpen = false);
    }
  }

  @override
  Component build(BuildContext context) {
    return nav(
      classes:
          'flex flex-col sm:flex-row w-full justify-between items-center px-4 sm:px-6 py-1 bg-white sm:bg-transparent shadow sm:shadow-none',
      [
        div(
          classes:
              'w-full sm:w-auto self-start sm:self-center flex flex-row sm:flex-none flex-no-wrap justify-between items-center',
          [
            // Logo and title
            a(
              href: '/',
              classes: 'no-underline flex flex-row items-center',
              [
                img(src: '/images/logo.png', alt: 'Remote Rift Logo', classes: 'h-12 py-1'),
                span(classes: 'pl-2 text-lg hover:text-brand-600', [.text(siteInfo.title)]),
              ],
            ),
            // Hamburger menu button (mobile only)
            button(
              classes: 'hamburger ${_menuOpen ? 'open ' : ''}block sm:hidden focus:outline-none',
              onClick: _toggleMenu,
              [
                span(classes: 'hamburger__top-bun', []),
                span(classes: 'hamburger__bottom-bun', []),
              ],
            ),
          ],
        ),
        // Navigation menu (responsive)
        div(
          classes: _menuOpen
              ? 'w-full sm:w-auto self-end sm:self-center flex flex-col sm:flex-row items-center h-full py-1 pb-4 sm:py-0 sm:pb-0'
              : 'w-full sm:w-auto self-end sm:self-center hidden sm:flex flex-col sm:flex-row items-center h-full py-1 pb-4 sm:py-0 sm:pb-0',
          [
            // Features link
            a(
              href: '#${siteContent.sectionIdFeatures}',
              classes:
                  'text-gray-800 hover:text-brand-600 text-lg text-center w-full no-underline sm:w-auto sm:px-4 py-2 sm:py-1',
              onClick: _closeMenu,
              [.text('Features')],
            ),
            // Download Now button
            a(
              href: '#${siteContent.sectionIdDownload}',
              classes:
                  'text-gray-800 border border-brand-300 text-lg bg-gray-100 rounded-full w-auto no-underline text-center sm:text-left hover:border-brand-600 hover:text-brand-600 hover:bg-white hover:shadow-md px-6 py-1 my-2 sm:my-0 sm:ml-4',
              onClick: _closeMenu,
              [.text('Download Now')],
            ),
          ],
        ),
      ],
    );
  }
}
