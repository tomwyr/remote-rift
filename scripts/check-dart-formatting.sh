#!/usr/bin/env bash

set -euo pipefail

dart_files=$(git ls-files '*.dart' | grep -v '\.g\.dart$' || true)
if [[ -n "$dart_files" ]]; then
  dart format --output=none --set-exit-if-changed $dart_files
fi
