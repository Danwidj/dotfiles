#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dummy File
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Files

# Documentation:
# @raycast.description Open the dummy PDF folder in Finder, ready to drag a file into an upload field.

# Raycast runs scripts without the shell environment, so resolve the data dir here.
dir="${XDG_DATA_HOME:-$HOME/.local/share}/dummy-files"

if [ ! -d "$dir" ]; then
    echo "Missing $dir - run chezmoi apply"
    exit 1
fi

# Open the folder predictably: always one window (reused if already open),
# the same size, centred on the screen in use, in large icon view so the files
# are easy to drag. Finder saves the view for this folder only.
osascript - "$dir" <<'APPLESCRIPT' >/dev/null
use framework "AppKit"
use scripting additions

property windowWidth : 720
property windowHeight : 420

on run argv
    set theFolder to POSIX file (item 1 of argv) as alias

    -- Finder measures from the top left of the primary screen, AppKit from
    -- its bottom left, so flip the vertical axis.
    set primaryFrame to (current application's NSScreen's screens()'s firstObject())'s frame()
    set primaryHeight to item 2 of item 2 of primaryFrame
    set activeScreen to current application's NSScreen's mainScreen()
    if activeScreen is missing value then set activeScreen to current application's NSScreen's screens()'s firstObject()
    set screenFrame to activeScreen's visibleFrame()
    set screenX to item 1 of item 1 of screenFrame
    set screenY to item 2 of item 1 of screenFrame
    set screenWidth to item 1 of item 2 of screenFrame
    set screenHeight to item 2 of item 2 of screenFrame
    set leftEdge to (screenX + (screenWidth - windowWidth) / 2) as integer
    set topEdge to (primaryHeight - (screenY + screenHeight) + (screenHeight - windowHeight) / 2) as integer

    tell application "Finder"
        set theWindow to missing value
        repeat with candidate in (get Finder windows)
            if (target of candidate as alias) is theFolder then
                set theWindow to contents of candidate
                exit repeat
            end if
        end repeat
        if theWindow is missing value then set theWindow to make new Finder window to theFolder
        set current view of theWindow to icon view
        set icon size of icon view options of theWindow to 128
        set bounds of theWindow to {leftEdge, topEdge, leftEdge + windowWidth, topEdge + windowHeight}
        set index of theWindow to 1
        activate
    end tell
end run
APPLESCRIPT
echo "Opened dummy files"
