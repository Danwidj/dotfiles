#!/usr/bin/env bash
# run_once_after_vorssaint-restore.sh
# Restores Vorssaint's tracked preferences (keep-awake, monitor widgets,
# clipboard/menu-bar settings) from the chezmoi-managed plist.
# Runs once, after chezmoi has written ~/.config/vorssaint/com.vorssaint.utils.plist.

set -euo pipefail

PLIST="$HOME/.config/vorssaint/com.vorssaint.utils.plist"

if [[ ! -f "$PLIST" ]]; then
    echo "Vorssaint plist not found at $PLIST, skipping restore."
    exit 0
fi

if ! command -v defaults &>/dev/null; then
    echo "Error: 'defaults' not found (not macOS?). Skipping Vorssaint restore."
    exit 0
fi

echo "Restoring Vorssaint preferences from $PLIST..."
defaults import com.vorssaint.utils "$PLIST"
killall Vorssaint 2>/dev/null || true
echo "Done. Vorssaint will pick up restored settings on next launch."
