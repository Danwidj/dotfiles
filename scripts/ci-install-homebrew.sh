#!/usr/bin/env bash
# Install Homebrew (Linuxbrew) non-interactively. Linux-only: macOS runners
# already ship Homebrew. Callers still need to add the Linuxbrew bin dirs to
# PATH themselves (e.g. via $GITHUB_PATH in CI) after this script returns.

set -euo pipefail

NONINTERACTIVE=1 /bin/bash -c \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
