# Publish mobile releases with Fastlane

Contributors can build and validate Mobile from a public checkout without the project's store
accounts or release signing keys. To ship an official release, a maintainer updates the version and
build number in [the mobile pubspec](../../apps/mobile/pubspec.yaml), adds the matching
[changelog entry](../../apps/mobile/CHANGELOG.md), and pushes a `mobile-<version>` tag. The tag
starts three independent release paths after validation. GitHub Releases publishes the changelog,
signed APK ZIP, and iOS IPA signed for App Store Connect. In parallel, Fastlane uploads the signed
Android App Bundle and native debug symbols to Google Play `beta` and a separately built iOS IPA
to TestFlight.
Promote builds to production in each store console.

## 1. Release workflow

- Keep [pull-request validation](../../.github/workflows/validate_code.yml) read-only and free of
  release credentials for branches and forks. Preserve the local Android debug build and iOS
  simulator build paths. Contributors use their own Apple development signing for physical devices.
- The [mobile release workflow](../../.github/workflows/release_mobile.yml) calls
  [release preparation](../../.github/workflows/prepare_mobile_release.yml) once. Preparation
  requires a `mobile-<version>` tag, checks the pubspec version and build-number presence and the
  matching changelog entry, and runs code validation. Dispatch manual runs against the tag ref.
  Each release job checks out the tagged commit.
- After preparation succeeds, the entry workflow calls the
  [GitHub Releases workflow](../../.github/workflows/publish_mobile_github.yml) and
  [app store workflow](../../.github/workflows/publish_mobile_stores.yml) independently.
  The GitHub workflow receives the validated version and title. Google Play and TestFlight run as
  independent jobs in the app store workflow.
- In GitHub repository settings, restrict release tag creation to maintainers and protect tags
  from updates and deletion. Use repository Actions variables for non-sensitive identifiers
  and repository Actions secrets for credentials and signing material. The entry workflow
  forwards only the named secrets each publishing workflow uses. The store jobs each use their
  own store credentials and fail independently if those credentials are missing. Both Android
  builds use the Android upload keystore, and both iOS builds use the same App Store Connect
  signing inputs. Only TestFlight receives Apple upload credentials.
- The [Android](../../.github/actions/prepare-android-build/action.yml) and
  [iOS](../../.github/actions/prepare-ios-build/action.yml) preparation actions each set up Flutter
  and resolve dependencies from the workspace root. The Android action sets up Java 17 and
  restores the upload keystore on Ubuntu. The iOS action prepares signing on macOS 26.
  The iOS action and the Play job set up Ruby and install Fastlane with `gem install fastlane`.
  The workflows call the lanes in [Fastfile](../../apps/mobile/fastlane/Fastfile) from `apps/mobile`.
- All artifacts use Flutter's release configuration and the version and build number from the
  tagged pubspec. Before tagging, choose a build number accepted by both stores, with an Android
  version code higher than any code already uploaded.

## 2. Android build and upload

- Restore the existing Android upload keystore with
  [the signing script](../../scripts/release/restore-android-signing-key.sh). Pass the Play
  service-account JSON to Fastlane through the upload step's environment. Grant the service
  account permission to release to the beta track for the registered Android app.
- Run `flutter build appbundle --release` in the Play job. Package the matching native debug
  symbols from the release bundle build as `native-debug-symbols.zip`. Use the
  unstripped libraries from the release build and preserve the ABI directories at the root of the
  ZIP.
- Implement `android deploy` with `upload_to_play_store`. Read the expected application ID from
  `ANDROID_APPLICATION_ID` injected by CI. Use the service-account JSON to upload the release AAB
  and native symbols ZIP. Google Play validates the bundle against that ID. Target the
  `beta` track and restrict the upload to the bundle and symbols. Store listing metadata stays in
  Play Console.

## 3. iOS signing, build, and upload

- For both iOS jobs, the preparation action restores the Apple Distribution certificate, App Store
  Connect provisioning profile, and `ExportOptions.plist` from CI secrets with
  [restore-ios-signing-files.sh](../../scripts/release/restore-ios-signing-files.sh). Configure the
  plist for a signed App Store Connect export that produces a local IPA and preserves the pubspec
  build number.
  Set the CI bundle and team IDs to match the app, provisioning profile, and export settings.
  Xcode validates the signing inputs during the build and export.
- Implement `ios setup_signing` to create and unlock a temporary keychain, import the certificate,
  install the provisioning profile, and use it for manual signing in the app target's Release
  configuration. Scope signing changes to the CI checkout so local development stays automatic.
- Both jobs run `flutter build ipa --release --export-options-plist=<path>` independently. The
  GitHub job packages its IPA. In the TestFlight job, `ios deploy` selects the single IPA in
  `build/ios/ipa` and uploads it with `upload_to_testflight`, using `IOS_BUNDLE_ID`
  and the numeric `APP_STORE_CONNECT_APP_ID` from the CI environment. Inject `APP_STORE_CONNECT_PROVIDER_ID`
  when required for an account associated with multiple providers. Inject the upload account and
  `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` from CI secrets.
  Skip waiting for build processing. Tester assignment and distribution are managed in App Store
  Connect after processing.

## 4. Artifacts and release verification

- [Package the signed APK and IPA](../../scripts/release/package-release.sh) as
  `remoterift-<version>.apk.zip` and `remoterift-<version>.ipa`, respectively. The GitHub release
  job waits for both builds, downloads their artifacts, and publishes them with the notes for the
  tag. The publishing job has repository write access. The build jobs use read access.
- In public release notes, label the APK as a sideload download and explain that manual iOS
  installation requires re-signing the IPA for the device. If the public APK and Google Play
  builds use different signing keys, explain that users must uninstall one build before switching
  channels.
- Keep credential files out of build outputs and uploaded artifacts. GitHub-hosted runners are
  discarded after each job, along with the temporary files, iOS keychain, and installed
  provisioning profile. Fail if required credentials or build outputs are missing.
- Before a live release, verify that fork pull requests can validate and publishing jobs require a
  valid mobile release tag. Check that the APK and both IPAs are signed for the intended app. Verify
  that each store job can fail without blocking the other destinations, and that a GitHub asset
  build failure blocks only GitHub publication. On the first approved release, confirm the AAB
  and symbols in Play Console, the processed build in TestFlight, and the APK ZIP and IPA on
  GitHub. Rerun only the failed jobs after fixing the cause. Check the store before retrying an
  upload whose result is uncertain.
- The [README release section](../../README.md#releases) documents the App stores and GitHub
  Releases channels and how readers can install the app. Replace the beta link placeholders when
  the public Google Play and TestFlight links are available.
