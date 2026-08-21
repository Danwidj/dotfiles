#!/usr/bin/env bash
# run_once_packages.sh
# Installs all packages from ~/.Brewfile via brew bundle.
# Runs after chezmoi applies files (so ~/.Brewfile is already in place).

set -euo pipefail

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

echo "Installing packages from ~/.Brewfile..."
brew bundle --global
echo "Done."
