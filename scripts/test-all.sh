#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

for manifest in apps/*/pubspec.yaml packages/*/pubspec.yaml; do
  package_dir=$(dirname "$manifest")
  [[ -d "$package_dir/test" ]] || continue

  if grep -q '^  flutter:' "$manifest"; then
    (cd "$package_dir" && flutter test --no-pub)
  else
    (cd "$package_dir" && dart test)
  fi
done
