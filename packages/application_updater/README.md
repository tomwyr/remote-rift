# Application Updater

A Dart package for enabling runtime application updates.

The package currently supports Windows and macOS desktop platforms and uses GitHub Releases as the source for distributing application updates.

> [!note]
> GitHub API requests are unauthenticated and may be subject to rate limits. For more information, see the [GitHub API rate limits documentation](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api).

## Features

- Check if a newer version is available
- Download and install the latest release.
- Backup and restore application if the update fails.

## Installation

1. Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  application_updater:
```

2. Run `dart pub get` to install dependencies.

3. Build the updater executable by running:

```sh
dart build cli bin/run_update.dart
```

4. Bundle the resulting executable with your application as an asset.

> [!important]
> The updater executable must be bundled with your application and accessible at runtime.

## Configuration

Configure the updater with your GitHub repository details and platform-specific settings:

```dart
import 'package:application_updater/application_updater.dart';

final updater = DesktopUpdater(
  releases: GitHubReleases(
    repoName: 'repo',
    userName: 'example',
    tagPrefix: 'desktop-',
    resolveArtifactName: (releaseTag) => 'app_$releaseTag.zip',
  ),
  updateRunner: UpdateRunner.platform(
    applicationLabel: 'App',
    macosBundleName: 'App.app',
    windowsExecutableName: 'App.exe',
  ),
);
```

## Usage

### Check for Updates

```dart
final update = await updater.checkUpdateAvailable();
if (update != null) {
  print('Update available: ${update.version}');
}
```

### Install an Update

```dart
await updater.installUpdate(update: update);
```

The update installation process performs the following steps:

- Closes the running application
- Replaces application files with the downloaded release
- Restarts the application after successful installation

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on the GitHub repository.

## License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
