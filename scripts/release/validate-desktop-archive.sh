#!/usr/bin/env bash

set -euo pipefail

platform="${1:?Expected a platform.}"
archive="${2:?Expected an archive path.}"

case "$platform" in
  windows)
    workdir=$(mktemp -d)
    trap 'rm -rf "$workdir"' EXIT
    powershell.exe -NoProfile -Command \
      "Expand-Archive -LiteralPath '$archive' -DestinationPath '$workdir'; if (!(Test-Path '$workdir/RemoteRift.exe') -or !(Test-Path '$workdir/data')) { exit 1 }"
    ;;
  macos)
    unzip -Z1 "$archive" | grep -q '^Remote Rift.app/'
    ;;
  *)
    echo "Unsupported desktop platform: $platform" >&2
    exit 1
    ;;
esac
