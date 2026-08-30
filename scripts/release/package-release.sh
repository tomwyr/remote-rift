#!/usr/bin/env bash

set -euo pipefail

platform="${1:?Expected a platform.}"
version="${2:?Expected a release version.}"

mkdir -p dist

case "$platform" in
  android)
    zip -q -j "dist/remoterift-$version.apk.zip" \
      apps/mobile/build/app/outputs/flutter-apk/app-release.apk
    ;;
  ios)
    bundle_name="remoterift-$version.app"
    ditto apps/mobile/build/ios/iphoneos/Runner.app "dist/$bundle_name"
    ditto -c -k --keepParent "dist/$bundle_name" "dist/$bundle_name.zip"
    ;;
  windows)
    powershell.exe -NoProfile -Command \
      "Compress-Archive -Path 'apps/desktop/build/windows/x64/runner/Release/*' -DestinationPath 'dist/RemoteRift-desktop-$version-windows.zip' -Force"
    ;;
  macos)
    ditto -c -k --keepParent \
      'apps/desktop/build/macos/Build/Products/Release/Remote Rift.app' \
      "dist/RemoteRift-desktop-$version-macos.zip"
    ;;
  *)
    echo "Unsupported release platform: $platform" >&2
    exit 1
    ;;
esac
