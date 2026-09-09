#!/usr/bin/env bash
# run_once_zz-set-default-apps.sh
#
# Sets macOS default application handlers (browser, PDF viewer, mail client,
# image viewer, plain-text editor, calendar, video player, archive utility)
# to match this machine's actual defaults at the time this script was
# written, using `duti` (installed via the Brewfile, see
# run_once_install-packages.sh).
#
# Runs after run_once_install-packages.sh (alphabetical run_once_ ordering:
# "install-packages" < "macos" < "zshenv" < "zz-set-default-apps" <
# "zzz-manual-steps"), so the casks/apps referenced below are already
# installed by the time this runs.
#
# Behavior when a target app isn't installed: `duti -s` looks up the bundle
# ID via Launch Services. If the bundle ID isn't registered (app not
# installed), duti exits non-zero and prints an error for that line, but
# does NOT abort the whole script (each call is independent). Since some
# entries below reference apps that may not exist on every machine (e.g.
# Preview/Safari/Mail/QuickTime are built-in and always present, but
# VS Code requires the "visual-studio-code" cask), failures are tolerated
# with `|| true` and a warning, rather than treated as fatal.
#
# NOTE: macOS has no concept of a "default terminal app" - Terminal.app (or
# whatever's pinned/opened) launches independently of any other terminal
# apps installed, so there is nothing to set here for that category.

set -uo pipefail

if ! command -v duti &>/dev/null; then
    echo "duti not found on PATH - it should have been installed via the Brewfile"
    echo "(see run_once_install-packages.sh). Skipping default-app assignment."
    exit 0
fi

set_default() {
    local bundle_id="$1" uti_or_ext="$2" role="${3:-all}"
    if duti -s "$bundle_id" "$uti_or_ext" "$role" 2>/dev/null; then
        echo "Set $bundle_id as handler for $uti_or_ext ($role)"
    else
        echo "Warning: could not set $bundle_id as handler for $uti_or_ext (app likely not installed) - skipping"
    fi
}

# --- Web browser (http/https URL schemes + HTML documents) -----------------
set_default com.apple.Safari http
set_default com.apple.Safari https
set_default com.apple.Safari public.html

# --- PDF viewer --------------------------------------------------------------
set_default com.apple.Preview com.adobe.pdf

# --- Mail client (mailto: URL scheme) ---------------------------------------
set_default com.apple.mail mailto

# --- Image viewer (PNG / JPEG) ----------------------------------------------
set_default com.apple.Preview public.png
set_default com.apple.Preview public.jpeg

# --- Plain text editor -------------------------------------------------------
set_default com.microsoft.VSCode public.plain-text

# --- Calendar (webcal: URL scheme + .ics files) ------------------------------
set_default com.apple.ical webcal
set_default com.apple.calendarfilehandler com.apple.ical.ics

# --- Video player (.mp4 / public.movie) --------------------------------------
set_default com.apple.QuickTimePlayerX public.movie

# --- Archive/zip handler ------------------------------------------------------
set_default com.apple.archiveutility public.zip-archive

echo "Default app assignment complete."
