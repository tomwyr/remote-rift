#!/usr/bin/env bash

set -euo pipefail

tag="${1:?Expected a release tag.}"

case "$tag" in
  mobile-*)
    product='mobile'
    version="${tag#mobile-}"
    pubspec='apps/mobile/pubspec.yaml'
    changelog='apps/mobile/CHANGELOG.md'
    title_prefix='Mobile'
    ;;
  desktop-*)
    product='desktop'
    version="${tag#desktop-}"
    pubspec='apps/desktop/pubspec.yaml'
    changelog='apps/desktop/CHANGELOG.md'
    title_prefix='Desktop'
    ;;
  *)
    echo "Unsupported release tag: $tag" >&2
    exit 1
    ;;
esac

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Release tag must end with a semantic version: $tag" >&2
  exit 1
fi

pubspec_version=$(sed -nE 's/^version:[[:space:]]*([^+[:space:]]+).*/\1/p' "$pubspec")
if [[ "$pubspec_version" != "$version" ]]; then
  echo "Tag version $version does not match $pubspec version $pubspec_version" >&2
  exit 1
fi

if ! grep -Fq "## [$version] - " "$changelog"; then
  echo "Missing changelog entry for $version in $changelog" >&2
  exit 1
fi

if [[ -z "${GITHUB_OUTPUT:-}" ]]; then
  echo 'GITHUB_OUTPUT must be set.' >&2
  exit 1
fi

{
  echo "product=$product"
  echo "version=$version"
  echo "title=$title_prefix $version"
} >> "$GITHUB_OUTPUT"
