#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root/apps/website"

tailwindcss --input styles.tw.css --output web/styles.css --watch &
tailwind_pid=$!

jaspr serve &
jaspr_pid=$!

cleanup() {
  trap - EXIT INT TERM
  kill "$tailwind_pid" "$jaspr_pid" 2>/dev/null || true
  wait "$tailwind_pid" 2>/dev/null || true
  wait "$jaspr_pid" 2>/dev/null || true
}

handle_interrupt() {
  cleanup
  exit 130
}

handle_termination() {
  cleanup
  exit 143
}

trap cleanup EXIT
trap handle_interrupt INT
trap handle_termination TERM

wait "$tailwind_pid"
wait "$jaspr_pid"
