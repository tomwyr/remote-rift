# Migration Plan: 11ty → Jaspr

## Overview
Migrate the Remote Rift landing page from Eleventy (11ty) to Jaspr while maintaining the single-page design, content structure, and visual appearance.

## Configuration Choices
1. **Routing**: Single-page with scroll-to-section navigation (like original)
2. **Styling**: Tailwind CSS (closer to original styling)
3. **Content**: Separate Dart files for data (maintainability)
4. **Assets**: Use `web/images/` directory (Jaspr convention)
5. **Mobile Menu**: @client component with Dart interactivity

---

## Phase 1: Setup & Dependencies

### 1.1 Add Tailwind CSS to Jaspr project
- Install Tailwind CSS npm packages
- Configure Tailwind in the project
- Set up build process to compile Tailwind

### 1.2 Configure Tailwind
- Port custom brand colors from 11ty config
- Set up responsive breakpoints (sm: 640px, md: 768px, lg: 1024px, xl: 1280px)
- Configure purge paths for Jaspr templates

**Brand Colors to Port:**
```javascript
brand: {
  50: "#f9f5e8",
  100: "#f3e8c7",
  200: "#ead189",
  300: "#e0bb5e",
  400: "#d7ae4d",
  500: "#d0ad4f", // main
  600: "#b69141",
  700: "#967436",
  800: "#7a5c2c",
  900: "#644b24",
}
brand-charcoal: {
  100: "#c2dcea",
  200: "#85b8d5",
  300: "#4995c1",
  400: "#2f6889",
  500: "#1a3a4c",
  600: "#152e3d",
  700: "#10232e",
  800: "#0a171e",
  900: "#050c0f",
}
```

---

## Phase 2: Static Assets Migration

### 2.1 Copy images to `web/images/`

**From:** `../remote-rift-website-11ty/public/img/`
**To:** `web/images/`

**Assets to migrate:**
- `logo.png` - Main logo
- `showcase.png` - Hero showcase image
- `icon_mobile.svg` - Remote queue control feature
- `icon_sync.svg` - Lobby updates feature
- `icon_coffee.svg` - Make wait useful feature
- `icon_rocket.svg` - More coming soon feature
- `icon_app_store.svg` - App Store download badge
- `icon_play_store.svg` - Play Store download badge

### 2.2 Organize assets structure
Consider creating subdirectories:
- `web/images/branding/` - logo, favicon
- `web/images/showcase/` - hero images
- `web/images/features/` - feature icons
- `web/images/downloads/` - app store badges

---

## Phase 3: Data & Content Structure

### 3.1 Create Dart data models

**`lib/models/feature.dart`**
```dart
class Feature {
  final String title;
  final String icon;
  final String content;

  Feature({required this.title, required this.icon, required this.content});
}
```

**`lib/models/download.dart`**
```dart
class DownloadLink {
  final String? label;
  final String? icon;

  DownloadLink({this.label, this.icon});
}

class DownloadOption {
  final String title;
  final String description;
  final List<DownloadLink> links;

  DownloadOption({required this.title, required this.description, required this.links});
}
```

**`lib/models/footer_link.dart`**
```dart
class FooterLink {
  final String title;
  final String url;
  final String urlDisplay;

  FooterLink({required this.title, required this.url, required this.urlDisplay});
}
```

**`lib/models/site_data.dart`**
```dart
class SiteData {
  final String author;
  final String title;
  final String description;
  final String language;
  final String copyright;

  SiteData({
    required this.author,
    required this.title,
    required this.description,
    required this.language,
    required this.copyright,
  });
}
```

### 3.2 Create data constants

**`lib/data/features.dart`** - Convert from `src/_data/features.json`
```dart
const List<Feature> features = [
  Feature(
    title: "Remote queue control",
    icon: "icon_mobile.svg",
    content: "Start or accept matches directly from your device while the client runs on the PC. Manage the queue without staying in front of it.",
  ),
  Feature(
    title: "Lobby and queue updates",
    icon: "icon_sync.svg",
    content: "See the current queue or lobby state from your device — know when a match is found or the game is about to start.",
  ),
  Feature(
    title: "Make the wait useful",
    icon: "icon_coffee.svg",
    content: "Handle other tasks, grab a snack, or relax while waiting for the next match. You'll know exactly when it's time to get back.",
  ),
  Feature(
    title: "... and more soon",
    icon: "icon_rocket.svg",
    content: "Stay tuned for upcoming features.",
  ),
];
```

**`lib/data/downloads.dart`** - Convert from `src/_data/downloads.json`
```dart
const List<DownloadOption> downloads = [
  DownloadOption(
    title: "Desktop",
    description: "Run the client connector to link your League account and enable remote access.",
    links: [
      DownloadLink(label: "Windows"),
      DownloadLink(label: "macOS"),
    ],
  ),
  DownloadOption(
    title: "Mobile",
    description: "Use the app to queue, accept matches, and check status from your phone or watch.",
    links: [
      DownloadLink(icon: "icon_app_store.svg"),
      DownloadLink(icon: "icon_play_store.svg"),
    ],
  ),
];
```

**`lib/data/footer_links.dart`** - Convert from `src/_data/footerLinks.json`
```dart
const List<FooterLink> footerLinks = [
  FooterLink(
    title: "Source code",
    url: "https://github.com/tomwyr/remote-rift-website",
    urlDisplay: "GitHub",
  ),
  FooterLink(
    title: "Built with Jaspr",
    url: "https://jaspr.dev",
    urlDisplay: "Jaspr",
  ),
];
```

**`lib/data/site_info.dart`** - Convert from `src/_data/site.json`
```dart
final siteInfo = SiteData(
  author: "Tomasz Wyrowiński",
  title: "Remote Rift",
  description: "Remote access for the League client.",
  language: "en",
  copyright: "© 2025 Tomasz Wyrowiński",
);
```

### 3.3 Create content strings

**`lib/data/content.dart`** - Convert from Markdown files
```dart
const aboutContent = "Join, accept, and monitor matchmaking queues from a phone, making it easier to step away from the PC while waiting for the next game to start.";

const featuresTitle = "Features";
const featuresContent = "Explore what makes matchmaking more convenient and hassle-free.";

const downloadTitle = "Downloads";
const downloadContent = "Download Remote Rift to connect the League client with your phone.";
```

---

## Phase 4: Component Architecture

### 4.1 Create reusable components

**`lib/components/navbar.dart`**
- Responsive navbar component
- Mobile hamburger menu with @client annotation
- Links to #features and #download
- Logo integration
- State management for menu toggle

**`lib/components/footer.dart`**
- Footer with copyright text
- Links section (GitHub, template credit)
- Proper styling with Tailwind classes

**`lib/components/back_to_top.dart`**
- Fixed position button at bottom-right
- Smooth scroll to top functionality
- Proper hover states
- Icon integration

**`lib/components/section_about.dart`**
- Hero section with logo
- Main headline and description
- "More Information" call-to-action button
- Showcase image integration

**`lib/components/section_features.dart`**
- Features grid layout
- Icon + title + description for each feature
- Responsive: 1 column mobile, 2 columns desktop
- "Download Now" call-to-action button

**`lib/components/section_download.dart`**
- Download options cards
- "Coming soon" badges on disabled links
- Responsive layout
- App store icons integration

### 4.2 Update main App component

**`lib/app.dart` modifications:**
- Remove routing (single page)
- Add smooth scrolling behavior
- Compose all sections in order:
  - Header (Navbar + About)
  - Main (Features + Download)
  - Footer
  - Back-to-top button
- Import all data and components

---

## Phase 5: Styling & Tailwind Integration

### 5.1 Apply Tailwind classes

**Key classes to port from Nunjucks templates:**

**Navbar:**
```html
flex flex-col sm:flex-row justify-between items-center px-4 sm:px-6 py-1 bg-white sm:bg-transparent shadow sm:shadow-none
```

**About Section:**
```html
w-full min-h-screen flex flex-col justify-between
```

**Features Section:**
```html
w-full min-h-screen flex flex-col justify-between items-center bg-brand-charcoal-500
```

**Download Section:**
```html
w-full min-h-screen flex flex-col justify-center items-center bg-gray-800 pb-12 px-4 md:px-8 lg:px-12 gap-8 md:gap-12 lg:gap-16
```

**Footer:**
```html
w-full flex flex-col text-lg tracking-wide px-4 sm:px-0 pt-6 pb-4 gap-4
```

### 5.2 Configure Tailwind with Jaspr

**Setup steps:**
1. Initialize Tailwind in project
2. Configure `tailwind.config.js`
3. Add CSS input file
4. Integrate with Jaspr build process
5. Ensure output CSS is included in HTML template

---

## Phase 6: Interactivity

### 6.1 Mobile menu implementation

**Create `@client` component:**
```dart
@client
class Navbar extends StatefulComponent {
  // State management for menu toggle
  // Smooth animations
  // Touch-friendly interactions
}
```

**Features needed:**
- Menu open/close state
- Hamburger button with animation
- Mobile menu dropdown
- Smooth transitions

### 6.2 Smooth scrolling

**Implementation:**
- Configure CSS `scroll-behavior: smooth`
- Add proper IDs to sections (about, features, download)
- Ensure offset for fixed navbar
- Handle scroll events for back-to-top button visibility

---

## Phase 7: Testing & Deployment

### 7.1 Content verification
- All text matches original exactly
- All links work correctly
- Images display properly
- Spacing and layout match

### 7.2 Responsive testing
- **Mobile (< 640px)**:
  - Hamburger menu works
  - Single column layout
  - Touch targets are large enough
- **Tablet (640px - 1024px)**:
  - Proper grid layouts
  - Responsive padding/margins
- **Desktop (> 1024px)**:
  - Full layout visible
  - Hover states work

### 7.3 Build verification
- Static generation works without errors
- Output files are generated correctly
- Tailwind CSS is compiled
- All assets are included
- Site can be served statically

---

## File Structure After Migration

```
lib/
├── app.dart                    # Main single-page component
├── main.server.dart
├── main.client.dart
├── models/
│   ├── feature.dart
│   ├── download.dart
│   ├── footer_link.dart
│   └── site_data.dart
├── data/
│   ├── features.dart
│   ├── downloads.dart
│   ├── footer_links.dart
│   ├── site_info.dart
│   └── content.dart
├── components/
│   ├── navbar.dart           # @client component
│   ├── footer.dart
│   ├── back_to_top.dart
│   ├── section_about.dart
│   ├── section_features.dart
│   └── section_download.dart
web/
├── images/
│   ├── logo.png
│   ├── showcase.png
│   ├── icon_mobile.svg
│   ├── icon_sync.svg
│   ├── icon_coffee.svg
│   ├── icon_rocket.svg
│   ├── icon_app_store.svg
│   └── icon_play_store.svg
├── favicon.ico
├── styles.css                # Tailwind output
└── index.html                # HTML template
package.json                  # NPM dependencies (Tailwind)
tailwind.config.js            # Tailwind configuration
```

---

## Key Migration Considerations

### Tailwind CSS Integration
- Needs to work with Jaspr's build process
- May need custom build scripts
- CSS should be compiled and included in static output

### Mobile Menu
- Requires `@client` annotation for interactivity
- State management with hooks
- Touch-friendly sizing (min 44px tap targets)

### Data Separation
- Keeps content maintainable like original
- Easy to update text without touching components
- Follows separation of concerns

### Single Page Architecture
- No routing needed, just smooth scrolling
- All content on one page
- Anchor links for navigation

### Deployment
- Can still use GitHub Pages
- Static site generation
- Same deployment workflow as original

---

## Estimated Timeline

- **Phase 1**: 1-2 hours (Tailwind setup)
- **Phase 2**: 30 minutes (assets)
- **Phase 3**: 1-2 hours (data conversion)
- **Phase 4**: 4-6 hours (component development)
- **Phase 5**: 2-3 hours (styling)
- **Phase 6**: 1-2 hours (interactivity)
- **Phase 7**: 2-3 hours (testing)

**Total**: 11-18 hours

---

## Next Steps

1. Review and approve this plan
2. Begin with Phase 1: Setup & Dependencies
3. Work through each phase systematically
4. Test incrementally after each phase
5. Deploy when complete
