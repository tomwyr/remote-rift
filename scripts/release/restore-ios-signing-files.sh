#!/usr/bin/env bash

set -euo pipefail

umask 077
signing_dir="${RUNNER_TEMP:?}/ios-signing"
mkdir "$signing_dir"
printf '%s' "$IOS_CERTIFICATE_P12_BASE64" | base64 -D > "$signing_dir/distribution.p12"
printf '%s' "$IOS_PROVISIONING_PROFILE_BASE64" | base64 -D > "$signing_dir/distribution.mobileprovision"
