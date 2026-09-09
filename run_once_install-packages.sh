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

# Run quietly; on failure, dump the captured output before exiting so the
# real error is still visible (not just "brew bundle failed").
run_bundle_quiet() {
    local out
    if out=$(brew bundle "$@" 2>&1); then
        echo "$out" | tail -1
    else
        echo "$out"
        return 1
    fi
}

echo "Installing packages from $HOMEBREW_BUNDLE_FILE_GLOBAL..."
run_bundle_quiet --global

# Optional machine-local overlay, untracked/gitignored (see README Gotchas
# for the local-overlay pattern). Skip silently if it doesn't exist.
LOCAL_BREWFILE="$HOME/.config/homebrew/Brewfile.local"
if [[ -f "$LOCAL_BREWFILE" ]]; then
    echo "Installing packages from $LOCAL_BREWFILE..."
    run_bundle_quiet --file="$LOCAL_BREWFILE"
fi

# Configure weekly auto-update (domt4/autoupdate tap, installed above):
# brew update + upgrade formulae/casks + cleanup, skipped while on battery,
# notifications only on failure. `start` errors if already configured, so
# guard on the launchd plist it installs.
AUTOUPDATE_PLIST="$HOME/Library/LaunchAgents/com.github.domt4.homebrew-autoupdate.plist"
if [[ ! -f "$AUTOUPDATE_PLIST" ]]; then
    # Newer Homebrew refuses to load external-command taps until trusted;
    # non-interactive and idempotent (no-ops if already trusted).
    brew trust --tap domt4/autoupdate
    brew autoupdate start 1w --upgrade --cleanup --ac-only --notify-on-error
    echo "brew autoupdate configured (weekly, AC-only, notify on failure only)."
else
    echo "brew autoupdate already configured. Skipping."
fi
