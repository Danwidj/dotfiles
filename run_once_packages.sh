#!/usr/bin/env bash
# run_once_packages.sh
# Installs all packages from $HOMEBREW_BUNDLE_FILE_GLOBAL (~/.config/homebrew/Brewfile) via brew bundle.
# Runs after chezmoi applies files (so the Brewfile is already in place).

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

# This script runs standalone via chezmoi (not sourced from zshrc), so the
# env var zshrc normally exports isn't set here — export it explicitly.
export HOMEBREW_BUNDLE_FILE_GLOBAL="$HOME/.config/homebrew/Brewfile"

echo "Installing packages from $HOMEBREW_BUNDLE_FILE_GLOBAL..."
brew bundle --global
echo "Done."

# Optional machine-local overlay for casks/formulae not tracked in the public
# dotfiles repo (mirrors the ~/.config/zsh/custom.zsh pattern). This file is
# untracked and ignored by chezmoi (see .chezmoiignore), so it may not exist
# yet on a fresh machine — skip silently if so.
#
# NOTE: this script is run_once, so it will NOT re-run after this point on
# this machine. And because Brewfile.local is untracked/unhashed by chezmoi,
# a run_onchange_ script wouldn't re-trigger on edits to it either. So: after
# adding entries to Brewfile.local, run this by hand to pick them up:
#   brew bundle --file="$HOME/.config/homebrew/Brewfile.local"
LOCAL_BREWFILE="$HOME/.config/homebrew/Brewfile.local"
if [[ -f "$LOCAL_BREWFILE" ]]; then
    echo "Installing packages from $LOCAL_BREWFILE..."
    brew bundle --file="$LOCAL_BREWFILE"
    echo "Done."
else
    echo "No local Brewfile found at $LOCAL_BREWFILE, skipping."
fi
