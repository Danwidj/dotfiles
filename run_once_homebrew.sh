#!/usr/bin/env bash
# run_once_homebrew.sh
# Installs Homebrew and Xcode Command Line Tools if not present.
# chezmoi runs this once on first apply (alphabetically before macos + packages).

set -euo pipefail

if command -v brew &>/dev/null; then
    echo "Homebrew already installed. Skipping."
    exit 0
fi

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add brew to PATH for subsequent scripts in this session
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Homebrew installed."
