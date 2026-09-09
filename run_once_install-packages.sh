#!/usr/bin/env bash
# run_once_install-packages.sh
# Installs Homebrew + Xcode CLT if missing, then installs all packages from
# $HOMEBREW_BUNDLE_FILE_GLOBAL (~/.config/homebrew/Brewfile) via brew bundle.
# Runs after chezmoi applies files (so the Brewfile is already in place).

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
    echo "Error: brew not found. Run chezmoi apply again after Homebrew is installed."
    exit 1
fi

# This script runs standalone via chezmoi (not sourced from zshrc), so the
# env var zshrc normally exports isn't set here — export it explicitly.
export HOMEBREW_BUNDLE_FILE_GLOBAL="$HOME/.config/homebrew/Brewfile"

echo "Installing packages from $HOMEBREW_BUNDLE_FILE_GLOBAL..."
brew bundle --global
echo "Done."

# Optional machine-local overlay, untracked/gitignored (see README Gotchas
# for the local-overlay pattern). Skip silently if it doesn't exist.
LOCAL_BREWFILE="$HOME/.config/homebrew/Brewfile.local"
if [[ -f "$LOCAL_BREWFILE" ]]; then
    echo "Installing packages from $LOCAL_BREWFILE..."
    brew bundle --file="$LOCAL_BREWFILE"
    echo "Done."
else
    echo "No local Brewfile found at $LOCAL_BREWFILE, skipping."
fi
