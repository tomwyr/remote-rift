import 'package:jaspr/dom.dart';

// As your CSS styles are defined using just Dart, you can simply
// use global variables or methods for common things like colors.
const primaryColor = Color('#01589B');

// Defines the global CSS styles for this project.
//
// By using the @css annotation, these will be rendered automatically to CSS and included in your page.
@css
List<StyleRule> get styles => [
  css('html, body').styles(
    width: 100.percent,
    minHeight: 100.vh,
    padding: .zero,
    margin: .zero,
  ),
  css('h1').styles(
    margin: .unset,
    fontSize: 4.rem,
  ),
];
