#!/usr/bin/env bash
# run_once_before_install-homebrew.sh
# Installs Homebrew + Xcode CLT if missing.
# Runs before chezmoi applies files.

set -euo pipefail

if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed. Skipping."
fi

# Ensure brew is on PATH (Apple Silicon; falls back to Intel)
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v brew &>/dev/null; then
    echo "Error: brew not found. Run chezmoi apply again after Homebrew is installed." >&2
    exit 1
fi
