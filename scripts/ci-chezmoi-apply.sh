#!/usr/bin/env bash
# Run chezmoi init --apply against this repo's source state. Pass
# --exclude=scripts to render and apply every file without executing any
# run_once_*/run_onchange_* scripts (used on Linux, since this repo's scripts
# are macOS-only); omit it for a full apply including scripts (macOS only).

set -euo pipefail

chezmoi init --apply --source=. "$@"
