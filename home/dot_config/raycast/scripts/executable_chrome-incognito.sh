#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Chrome Incognito
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Browser
# @raycast.argument1 { "type": "text", "placeholder": "Link (empty = clipboard link)", "optional": true }

# Documentation:
# @raycast.description Open a Chrome incognito window. Opens the given link, or the clipboard's link when it holds one, otherwise a blank window.

url="$1"
source="given"

# Script command arguments cannot be prefilled, so fall back to the clipboard
# here: use it only when the whole clipboard is a single link.
if [ -z "$url" ]; then
    clipboard="$(pbpaste 2>/dev/null | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [[ "$clipboard" =~ ^(https?://|localhost[:/])[^[:space:]]+$ ]]; then
        url="$clipboard"
        source="clipboard"
    fi
fi

# -n is needed so Chrome honours --incognito when it is already running; the
# new process hands the window to the running Chrome and exits.
if [ -n "$url" ]; then
    open -na "Google Chrome" --args --incognito "$url"
    echo "Incognito: $source link"
else
    open -na "Google Chrome" --args --incognito
    echo "Incognito: new window"
fi
