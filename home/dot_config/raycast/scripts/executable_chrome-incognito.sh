#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Chrome Incognito
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Browser

# Documentation:
# @raycast.description Open a Chrome incognito window, on the clipboard's link when it holds one, otherwise blank.

# Use the clipboard only when the whole of it is a single link.
url=""
clipboard="$(pbpaste 2>/dev/null | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
if [[ "$clipboard" =~ ^(https?://|localhost[:/])[^[:space:]]+$ ]]; then
    url="$clipboard"
fi

# -n is needed so Chrome honours --incognito when it is already running; the
# new process hands the window to the running Chrome and exits.
if [ -n "$url" ]; then
    open -na "Google Chrome" --args --incognito "$url"
    echo "Incognito: clipboard link"
else
    open -na "Google Chrome" --args --incognito
    echo "Incognito: new window"
fi
