#!/usr/bin/env bash

set -euo pipefail

tag="${1:?Expected a release tag.}"
output_path="${2:?Expected an output path.}"

case "$tag" in
  mobile-*)
    version="${tag#mobile-}"
    changelog='apps/mobile/CHANGELOG.md'
    ;;
  desktop-*)
    version="${tag#desktop-}"
    changelog='apps/desktop/CHANGELOG.md'
    ;;
  *)
    echo "Unsupported release tag: $tag" >&2
    exit 1
    ;;
esac

mkdir -p "$(dirname "$output_path")"

awk -v heading="## [$version] - " '
  index($0, heading) == 1 { found = 1; next }
  found && /^## / { exit }
  found { print }
  END {
    if (!found) {
      exit 1
    }
  }
' "$changelog" > "$output_path"

if [[ ! -s "$output_path" ]]; then
  echo "No release notes found for $version in $changelog" >&2
  exit 1
fi
