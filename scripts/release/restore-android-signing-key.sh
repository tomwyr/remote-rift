#!/usr/bin/env bash

set -euo pipefail

for variable in \
  ANDROID_KEYSTORE_BASE64 \
  ANDROID_KEYSTORE_PASSWORD \
  ANDROID_KEY_ALIAS \
  ANDROID_KEY_PASSWORD; do
  if [[ -z "${!variable:-}" ]]; then
    echo "$variable must be set." >&2
    exit 1
  fi
done

keystore_path="${RUNNER_TEMP:?RUNNER_TEMP must be set.}/remoterift-release.jks"
umask 077
printf '%s' "$ANDROID_KEYSTORE_BASE64" | base64 --decode > "$keystore_path"

{
  printf 'ANDROID_KEYSTORE_PATH=%s\n' "$keystore_path"
  printf 'ANDROID_KEYSTORE_PASSWORD=%s\n' "$ANDROID_KEYSTORE_PASSWORD"
  printf 'ANDROID_KEY_ALIAS=%s\n' "$ANDROID_KEY_ALIAS"
  printf 'ANDROID_KEY_PASSWORD=%s\n' "$ANDROID_KEY_PASSWORD"
} >> "${GITHUB_ENV:?GITHUB_ENV must be set.}"
