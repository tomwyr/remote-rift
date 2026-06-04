# Phase 3 Implementation Plan: Data & Content Structure

## Overview
Create Dart data models and populate them with content from the 11ty project's JSON and Markdown files.

## Prerequisites
- Phase 2 (Static Assets Migration) completed
- Source project accessible at `../remote-rift-website-11ty/`
- Jaspr project structure exists

## Current State
- `lib/` directory exists
- `lib/constants/` exists with `theme.dart`
- `lib/components/` exists with sample components
- No data models or data files exist yet

## Implementation Steps

### Step 1: Create Models Directory
**Duration: 2 minutes**

Create the directory structure for data models:
```bash
mkdir -p lib/models
mkdir -p lib/data
```

### Step 2: Create Data Models
**Duration: 20 minutes**

Create 4 model files based on the JSON structure found in the 11ty project.

#### 2.1 Feature Model
**File:** `lib/models/feature.dart`

```dart
class Feature {
  const Feature({
    required this.title,
    required this.icon,
    required this.content,
  });

  final String title;
  final String icon;
  final String content;
}
```

#### 2.2 Download Models
**File:** `lib/models/download.dart`

```dart
class DownloadLink {
  const DownloadLink({
    this.label,
    this.icon,
  });

  final String? label;
  final String? icon;
}

class DownloadOption {
  const DownloadOption({
    required this.title,
    required this.description,
    required this.links,
  });

  final String title;
  final String description;
  final List<DownloadLink> links;
}
```

#### 2.3 Footer Link Model
**File:** `lib/models/footer_link.dart`

```dart
class FooterLink {
  const FooterLink({
    required this.title,
    required this.url,
    required this.urlDisplay,
  });

  final String title;
  final String url;
  final String urlDisplay;
}
```

#### 2.4 Site Data Model
**File:** `lib/models/site_data.dart`

```dart
class SiteData {
  const SiteData({
    required this.author,
    required this.title,
    required this.description,
    required this.language,
    required this.copyright,
  });

  final String author;
  final String title;
  final String description;
  final String language;
  final String copyright;
}
```

### Step 3: Create Data Constants
**Duration: 25 minutes**

Create data files by converting JSON content from the 11ty project to Dart constants.

#### 3.1 Features Data
**File:** `lib/data/features.dart`

**Source:** `../remote-rift-website-11ty/src/_data/features.json`

```dart
import '../models/feature.dart';

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

#### 3.2 Downloads Data
**File:** `lib/data/downloads.dart`

**Source:** `../remote-rift-website-11ty/src/_data/downloads.json`

```dart
import '../models/download.dart';

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

#### 3.3 Footer Links Data
**File:** `lib/data/footer_links.dart`

**Source:** `../remote-rift-website-11ty/src/_data/footerLinks.json`

```dart
import '../models/footer_link.dart';

const List<FooterLink> footerLinks = [
  FooterLink(
    title: "Source code",
    url: "https://github.com/tomwyr/remote-rift-website",
    urlDisplay: "GitHub",
  ),
  FooterLink(
    title: "Website template",
    url: "https://ttntm.me",
    urlDisplay: "ttntm.me",
  ),
];
```

#### 3.4 Site Info Data
**File:** `lib/data/site_info.dart`

**Source:** `../remote-rift-website-11ty/src/_data/site.json`

```dart
import '../models/site_data.dart';

final siteInfo = SiteData(
  author: "Tomasz Wyrowiński",
  title: "Remote Rift",
  description: "Remote access for the League client.",
  language: "en",
  copyright: "© 2025 Tomasz Wyrowiński",
);
```

### Step 4: Create Content Strings
**Duration: 10 minutes**

Create content strings by extracting text from the 11ty markdown files.

#### 2.5 Site Content Model
**File:** `lib/models/site_content.dart`

```dart
class SiteContent {
  const SiteContent({
    required this.aboutTitle,
    required this.aboutContent,
    required this.featuresTitle,
    required this.featuresContent,
    required this.downloadTitle,
    required this.downloadContent,
    required this.buttonMoreInformation,
    required this.buttonDownloadNow,
    required this.sectionIdAbout,
    required this.sectionIdFeatures,
    required this.sectionIdDownload,
  });

  final String aboutTitle;
  final String aboutContent;
  final String featuresTitle;
  final String featuresContent;
  final String downloadTitle;
  final String downloadContent;
  final String buttonMoreInformation;
  final String buttonDownloadNow;
  final String sectionIdAbout;
  final String sectionIdFeatures;
  final String sectionIdDownload;
}
```

#### 4.1 Main Content File
**File:** `lib/data/content.dart`

**Sources:**
- `../remote-rift-website-11ty/src/sections/about.md`
- `../remote-rift-website-11ty/src/sections/features.md`
- `../remote-rift-website-11ty/src/sections/download.md`

```dart
import '../models/site_content.dart';

final siteContent = SiteContent(
  aboutTitle: "Queue the next match remotely",
  aboutContent: "Join, accept, and monitor matchmaking queues from a phone, making it easier to step away from the PC while waiting for the next game to start.",
  featuresTitle: "Features",
  featuresContent: "Explore what makes matchmaking more convenient and hassle-free.",
  downloadTitle: "Downloads",
  downloadContent: "Download Remote Rift to connect the League client with your phone.",
  buttonMoreInformation: "More Information",
  buttonDownloadNow: "Download Now",
  sectionIdAbout: "about",
  sectionIdFeatures: "features",
  sectionIdDownload: "download",
);
```

### Step 5: Create Export File
**Duration: 5 minutes**

Create a barrel export file for easier imports.

#### 5.1 Models Export
**File:** `lib/models/models.dart`

```dart
export 'feature.dart';
export 'download.dart';
export 'footer_link.dart';
export 'site_data.dart';
export 'site_content.dart';
```

#### 5.2 Data Export
**File:** `lib/data/data.dart`

```dart
export 'features.dart';
export 'downloads.dart';
export 'footer_links.dart';
export 'site_info.dart';
export 'content.dart';
```

### Step 6: Verify Data Structure
**Duration: 10 minutes**

Verify all data files are syntactically correct and can be imported.

```bash
# Run Dart analyzer to check for syntax errors
dart analyze lib/models/
dart analyze lib/data/

# List all created files
find lib/models -name "*.dart"
find lib/data -name "*.dart"

# Verify file structure
tree lib/models lib/data
```

**Expected output:**
```
lib/models/
├── feature.dart
├── download.dart
├── footer_link.dart
├── site_data.dart
├── site_content.dart
└── models.dart

lib/data/
├── features.dart
├── downloads.dart
├── footer_links.dart
├── site_info.dart
├── content.dart
└── data.dart
```

## Total Estimated Duration: 62 minutes (1 hour 2 minutes)

## Success Criteria

- [ ] All 4 model files created in `lib/models/`
- [ ] All 5 data files created in `lib/data/`
- [ ] Export files created for easier imports
- [ ] Dart analyzer shows no syntax errors
- [ ] All content matches original 11ty files exactly
- [ ] Feature count: 4
- [ ] Download options: 2
- [ ] Footer links: 2
- [ ] Site info populated correctly
- [ ] All content strings defined

## Data Verification Checklist

### Features Data (from `features.json`)
- [ ] Remote queue control - icon_mobile.svg
- [ ] Lobby and queue updates - icon_sync.svg
- [ ] Make the wait useful - icon_coffee.svg
- [ ] ... and more soon - icon_rocket.svg

### Downloads Data (from `downloads.json`)
- [ ] Desktop - Windows, macOS labels
- [ ] Mobile - App Store, Play Store icons

### Footer Links (from `footerLinks.json`)
- [ ] Source code - GitHub URL
- [ ] Website template - ttntm.me URL

### Site Info (from `site.json`)
- [ ] Author: Tomasz Wyrowiński
- [ ] Title: Remote Rift
- [ ] Description: Remote access for the League client.
- [ ] Language: en
- [ ] Copyright: © 2025 Tomasz Wyrowiński

### Content Strings (from markdown files)
- [ ] aboutTitle: "Queue the next match remotely"
- [ ] aboutContent matches exactly
- [ ] featuresTitle: "Features"
- [ ] featuresContent matches exactly
- [ ] downloadTitle: "Downloads"
- [ ] downloadContent matches exactly

## Potential Issues & Solutions

### Issue 1: Dart analyzer shows import errors
**Solution:** Check that all file paths in imports are correct and use relative imports properly.

### Issue 2: Test import fails
**Solution:** Verify all constants are properly defined and match the expected data types.

### Issue 3: Content mismatch from original
**Solution:** Double-check JSON and markdown files in source project and update constants accordingly.

### Issue 4: Special characters not displaying correctly
**Solution:** Ensure copyright symbol and other special characters match exactly (copy from source if needed).

## Next Steps After Phase 3

Once Phase 3 is complete:
1. Verify all data can be imported in components
2. Begin Phase 4: Component Architecture
3. Use these data models in component implementations
4. Reference data constants when building UI components

## Notes

- All data is immutable (using `const`) for performance
- Constructors come first in class definitions
- Content strings separated from data for maintainability
- Export files (barrel files) make imports cleaner
- All content text preserved exactly from original files
- Special characters (like ©) preserved accurately
- No JSON serialization methods (fromJson/toJson) needed for static data