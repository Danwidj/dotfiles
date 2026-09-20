#!/usr/bin/env bash
# .macos — macOS system defaults
# Run: bash .macos
# Source: live prefs-export via macprefs (2026-08-21), with manual overrides noted
# Skipped: settings that match macOS factory defaults, instance-specific IDs,
#          volatile/state keys, CloudKit-backed settings

echo "Applying macOS defaults..."

###############################################################################
# Global / NSGlobalDomain
###############################################################################

# Disable liquid glass diffusion effect
defaults write -globalDomain NSGlassDiffusionSetting -bool false

# Row/icon size: small [default: medium (2)]
defaults write -globalDomain NSTableViewDefaultSizeMode -int 1

# Language / locale
defaults write -globalDomain AppleLanguages -array en-SG
defaults write -globalDomain AppleLocale -string en_SG

# Appearance: auto dark/light [default: light]
defaults write -globalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# 24-hour time [default: 12-hour]
defaults write -globalDomain AppleICUForce24HourTime -bool true

# Scroll bars: always visible [default: automatic]
defaults write -globalDomain AppleShowScrollBars -string Always

# Scroll bar click: jump to position [default: jump to page]
defaults write -globalDomain AppleScrollerPagingBehavior -bool true

# Show all file extensions [default: off]
defaults write -globalDomain AppleShowAllExtensions -bool true

# Double-click title bar: Fill [default: Zoom]
defaults write -globalDomain AppleActionOnDoubleClick -string Fill

# Tabs: never auto-create [OVERRIDE: default is fullscreen-only]
defaults write -globalDomain AppleWindowTabbingMode -string manual

# Autocorrect / smart substitutions: all off
defaults write -globalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write -globalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write -globalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -globalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -globalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -globalDomain NSAutomaticInlinePredictionEnabled -bool false
defaults write -globalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# Keyboard layout: ABC
defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID \
  -string com.apple.keylayout.ABC

# Open/save panel: list view [default: column]
defaults write -globalDomain NSNavPanelFileLastListModeForOpenModeKey -int 1
defaults write -globalDomain NSNavPanelFileListModeForOpenMode2 -int 1
defaults write -globalDomain NavPanelFileListModeForOpenMode -int 1

# Trackpad: fast tracking and scroll speed
defaults write -globalDomain com.apple.trackpad.scaling -float 3.0
defaults write -globalDomain com.apple.trackpad.scrolling -float 1.0

# Disable RSVP data detectors (Calendar event suggestions from text)
defaults write -globalDomain shouldShowRSVPDataDetectors -bool false

###############################################################################
# Dock
###############################################################################

# No pinned apps or pinned folders/stacks (e.g. the default Downloads pin)
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array

# Tile size [default: 48]
defaults write com.apple.dock tilesize -float 46

# No recent apps [default: on]
defaults write com.apple.dock show-recents -bool false

# No running indicators [default: on]
defaults write com.apple.dock show-process-indicators -bool false

# Group windows by app in Mission Control [default: off]
defaults write com.apple.dock expose-group-apps -bool true

# Auto-hide, minimal delay [default: off]
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3

###############################################################################
# Hot Corners
# Values: 1=off, 4=Desktop, 10=Sleep Display, 13=Lock Screen, 14=Quick Note
# Modifier: 0=none, 1048576=Command
###############################################################################

defaults write com.apple.dock wvous-tl-corner -int 1          # off
defaults write com.apple.dock wvous-tr-corner -int 4          # Desktop
defaults write com.apple.dock wvous-bl-corner -int 10         # Sleep Display
defaults write com.apple.dock wvous-br-corner -int 1          # off
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-modifier -int 1048576  # Command required
defaults write com.apple.dock wvous-bl-modifier -int 1048576  # Command required
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Finder
###############################################################################

# Column view by default [default: icon]
defaults write com.apple.finder FXPreferredViewStyle -string clmv

# Auto-size columns
defaults write com.apple.finder _FXEnableColumnAutoSizing -bool true

# Extension change warning: off [OVERRIDE: default is on]
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# iCloud Drive: Desktop + Documents
defaults write com.apple.finder FXICloudDriveEnabled -bool true
defaults write com.apple.finder FXICloudDriveDesktop -bool true
defaults write com.apple.finder FXICloudDriveDocuments -bool true

# No drives/media on Desktop [default: on]
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Open folders in new window, not tab [default: tab]
defaults write com.apple.finder FinderSpawnTab -bool false

# Search scope: current folder [default: This Mac]
defaults write com.apple.finder FXLastSearchScope -string SCcf

# Show hidden files [default: off]
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar [default: off]
defaults write com.apple.finder ShowPathbar -bool true

# No tags [default: on]
defaults write com.apple.finder ShowTagNames -bool false
defaults write com.apple.finder FavoriteTagNames -array
defaults write com.apple.finder ShowRecentTags -bool false

# List view: small icons, calculate all sizes
defaults write com.apple.finder NSTableViewDefaultSizeMode -int 1
defaults write com.apple.finder calculateAllSizes -bool true

# Bin: remove items after 30 days [default: off]
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# Column view everywhere + sort by Date Added, for every view type (so it
# still applies if a folder's saved view ever switches away from column).
# These are nested keys inside com.apple.finder's StandardViewSettings dict
# (the default applied to any folder without its own per-folder .DS_Store
# view override) - PlistBuddy is used instead of `defaults write -dict-add`
# because the latter replaces the whole sub-dict, wiping sibling keys like
# icon size / grid spacing instead of merging.
FINDER_PLIST="$HOME/Library/Preferences/com.apple.finder.plist"
for path in \
  ":StandardViewSettings:IconViewSettings:arrangeBy dateAdded" \
  ":StandardViewSettings:ExtendedListViewSettingsV2:sortColumn dateAdded" \
  ":StandardViewSettings:ListViewSettings:sortColumn dateAdded" \
  ":StandardViewSettings:GalleryViewSettings:arrangeBy dateAdded" \
  ":StandardViewSettings:ColumnViewSettings:arrangeBy dateAdded"; do
    key="${path%% *}"
    value="${path##* }"
    /usr/libexec/PlistBuddy -c "Set $key $value" "$FINDER_PLIST" 2>/dev/null \
      || /usr/libexec/PlistBuddy -c "Add $key string $value" "$FINDER_PLIST" 2>/dev/null
done

# Sidebar items live in binary .sfl3 files — not scriptable via defaults.
# See README.md "Manual setup" / run_once_zzz-manual-steps.sh for the sidebar
# and Recents-view steps.

###############################################################################
# Trackpad
###############################################################################

# Tap to click [default: off]
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Three-finger drag [default: off]
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Three-finger swipe: off (use four-finger instead)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0

# Two-finger swipe from right edge: off [OVERRIDE: default is Notification Centre]
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0

###############################################################################
# Window Manager
###############################################################################

# No margins between tiled windows [default: on]
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# No Desktop widgets at all [default: off/hidden already, but explicit]
defaults write com.apple.WindowManager StandardHideWidgets -bool true
defaults write com.apple.WindowManager StageManagerHideWidgets -bool true

###############################################################################
# Calendar
###############################################################################

defaults write com.apple.iCal 'TimeZone support enabled' -bool true
defaults write com.apple.iCal 'last calendar view description' -string 7-day
defaults write com.apple.iCal 'number of hours displayed' -int 16
defaults write com.apple.iCal 'first minute of work hours' -int 420    # 7am
defaults write com.apple.iCal 'last minute of work hours' -int 1440    # midnight
defaults write com.apple.iCal CalendarSidebarShown -bool false
defaults write com.apple.iCal 'display birthdays calendar' -bool true
defaults write com.apple.iCal InviteeDeclineAlerts -bool false
defaults write com.apple.iCal CalDefaultCalendar -string UseLastSelectedAsDefaultCalendar
defaults write com.apple.iCal enableTravelAdvisoriesForAutomaticBehavior -bool false

###############################################################################
# Spotlight
###############################################################################

# Clipboard history: on, 7-day retention
defaults write com.apple.Spotlight PasteboardHistoryEnabled -bool true
defaults write com.apple.Spotlight PasteboardHistoryTimeout -int 604800

###############################################################################
# Control Center (per-host — see note below)
###############################################################################

# NOTE: com.apple.controlcenter menu-bar item toggles (battery %, Spotlight,
# VoiceControl, etc.) live in a ByHost plist
# (~/Library/Preferences/ByHost/com.apple.controlcenter.<hw-uuid>.plist), not
# the regular ~/Library/Preferences/com.apple.controlcenter.plist. A plain
# `defaults read com.apple.controlcenter` misses them entirely — this is why
# the original macprefs export (2026-08-21) didn't capture battery percentage.
# Audited 2026-09-09: WiFi/Sound/Clock/NowPlaying visibility ("NSStatusItem
# VisibleCC <name>") turned out to live in the REGULAR (non-ByHost) domain
# plist instead, at their macOS defaults, so nothing to script for those.

# Show battery percentage in menu bar [default: off]
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# Spotlight / Voice Control menu-bar item visibility mode (per-item dropdown:
# Always Show / Show When Active / Don't Show) [default: differs per item;
# value 8 reproduces this machine's current choice for both]
defaults -currentHost write com.apple.controlcenter Spotlight -int 8
defaults -currentHost write com.apple.controlcenter VoiceControl -int 8

###############################################################################
# Screenshot
###############################################################################

# Enable video capture option in screenshot toolbar
defaults write com.apple.screencapture video -bool true

###############################################################################
# Power / Lock Screen
###############################################################################

# Sleep (display + system) after 5 min on both power sources [default: varies]
sudo pmset -a displaysleep 5 sleep 5

# Require password 5 min after sleep/screensaver starts [default: immediately]
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 300

###############################################################################
# Siri / Apple Intelligence — disabled entirely
###############################################################################

defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.Siri StatusMenuVisible -bool false

###############################################################################
# Tips — disabled entirely (Notification Center tips + in-app hint bubbles,
# both driven by the same com.apple.tipsd/TipKit daemon)
###############################################################################

# `bootout` of the currently-running instance is SIP-blocked (expected for a
# system agent) - `disable` still persists and takes effect from next login.
launchctl disable "gui/$(id -u)/com.apple.tipsd" 2>/dev/null || true

###############################################################################
# Login Items
###############################################################################

osascript <<'EOF'
tell application "System Events"
    set loginItemNames to name of every login item
    repeat with appName in {"Raycast", "Calendar", "Reminders"}
        if loginItemNames does not contain appName then
            make login item at end with properties {path:"/Applications/" & appName & ".app", hidden:false}
        end if
    end repeat
end tell
EOF

###############################################################################
# Default apps (via duti — installed from the Brewfile)
###############################################################################

# Sets macOS default application handlers to match this machine's actual
# defaults at the time this section was written.
#
# Behavior when a target app isn't installed: `duti -s` looks up the bundle
# ID via Launch Services. If it's not registered, duti exits non-zero for
# that line only — tolerated below with a warning, not fatal.
#
# NOTE: macOS has no concept of a "default terminal app" - Terminal.app (or
# whatever's pinned/opened) launches independently of other terminal apps
# installed, so there's nothing to set here for that category.

if ! command -v duti &>/dev/null; then
    echo "duti not found on PATH - it should have been installed via the Brewfile"
    echo "(see run_once_install-packages.sh). Skipping default-app assignment."
else
    # `duti -s <bundle_id> <uti|extension|MIME> <role>` (3 args) for UTIs.
    # Silent on success; only warns (real signal, not noise) on failure.
    set_default() {
        local bundle_id="$1" uti_or_ext="$2" role="${3:-all}"
        if ! duti -s "$bundle_id" "$uti_or_ext" "$role" 2>/dev/null; then
            echo "Warning: could not set $bundle_id as handler for $uti_or_ext (app likely not installed) - skipping"
        fi
    }

    # `duti -s <bundle_id> <url_scheme>` (2 args, NO role) for URL schemes.
    # Passing a 3rd arg here makes duti misinterpret the scheme as a UTI
    # string instead (resolves to a bogus dyn.* UTI and fails with -50).
    set_default_scheme() {
        local bundle_id="$1" scheme="$2"
        if ! duti -s "$bundle_id" "$scheme" 2>/dev/null; then
            echo "Warning: could not set $bundle_id as handler for $scheme: URLs (app likely not installed) - skipping"
        fi
    }

    # Web browser (http URL scheme + HTML documents). https is deliberately
    # not scripted here - macOS blocks programmatic changes to the default
    # web browser for that scheme specifically (anti-hijacking measure);
    # it already falls back to Safari (factory default) with no override.
    set_default_scheme com.apple.Safari http
    set_default com.apple.Safari public.html

    # PDF viewer
    set_default com.apple.Preview com.adobe.pdf

    # Mail client (mailto: URL scheme)
    set_default_scheme com.apple.mail mailto

    # Image viewer (PNG / JPEG)
    set_default com.apple.Preview public.png
    set_default com.apple.Preview public.jpeg

    # Plain text editor
    set_default com.microsoft.VSCode public.plain-text

    # Calendar (webcal: URL scheme + .ics files)
    set_default_scheme com.apple.ical webcal
    set_default com.apple.calendarfilehandler com.apple.ical.ics

    # Video player (.mp4 / public.movie)
    set_default com.apple.QuickTimePlayerX public.movie

    # Archive/zip handler
    set_default com.apple.archiveutility public.zip-archive

    echo "Default app handlers set."
fi

###############################################################################
# Keyboard Shortcuts
# Policy: everything is OFF, then only specific things are explicitly turned
# back ON below with their real keybindings. To add a new shortcut in future,
# just append another block/call after "Turn specific things ON" - no need to
# touch the blanket-off logic above it.
###############################################################################

HOTKEYS_PLIST="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
SERVICES_PLIST="$HOME/Library/Preferences/pbs.plist"

# --- Turn ALL keyboard shortcuts OFF ---
# Dynamically disables every id currently present in the plist, instead of a
# hardcoded id list, so this doesn't go stale as new defaults get touched over
# time. Note macOS only ever writes an id here once it's been touched at least
# once via System Settings - an id that's never been touched simply isn't
# present and silently stays at its factory default (this is how Screenshots
# behaved before being explicitly turned on below).
# Delete-then-Add (not Set): macOS stores `enabled` as an integer for some ids
# (e.g. 64) and a real boolean for others (e.g. 65) - Set fails with
# "Unrecognized Integer Format" against the integer-typed ones since it tries
# to preserve the existing type. Deleting first sidesteps the type entirely.
for id in $(/usr/bin/python3 -c "
import plistlib
try:
    with open('$HOTKEYS_PLIST', 'rb') as f:
        d = plistlib.load(f)
    print('\n'.join(d.get('AppleSymbolicHotKeys', {}).keys()))
except FileNotFoundError:
    pass
"); do
    /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:$id" "$HOTKEYS_PLIST" 2>/dev/null
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:$id:enabled bool false" "$HOTKEYS_PLIST"
done

# Services (right-click / Services menu items): same dynamic approach, except
# skip "New Ghostty Window Here" entirely - manually configured, left as-is.
KEEP_SERVICE="com.mitchellh.ghostty - New Ghostty Window Here - openWindow"
while IFS= read -r svc; do
    [ -z "$svc" ] && continue
    [ "$svc" = "$KEEP_SERVICE" ] && continue
    /usr/libexec/PlistBuddy -c "Set :NSServicesStatus:\"$svc\":enabled_services_menu false" "$SERVICES_PLIST" 2>/dev/null \
      || /usr/libexec/PlistBuddy -c "Add :NSServicesStatus:\"$svc\":enabled_services_menu bool false" "$SERVICES_PLIST"
    /usr/libexec/PlistBuddy -c "Set :NSServicesStatus:\"$svc\":enabled_context_menu false" "$SERVICES_PLIST" 2>/dev/null \
      || /usr/libexec/PlistBuddy -c "Add :NSServicesStatus:\"$svc\":enabled_context_menu bool false" "$SERVICES_PLIST"
done < <(/usr/bin/python3 -c "
import plistlib
try:
    with open('$SERVICES_PLIST', 'rb') as f:
        d = plistlib.load(f)
    for k in d.get('NSServicesStatus', {}):
        print(k)
except FileNotFoundError:
    pass
")

# --- Turn specific things back ON, with explicit keybindings ---
# Add new shortcuts here as needed. Each call is independent - it doesn't
# require touching the blanket-off logic above.
set_hotkey() {  # id ascii keycode modifiers
    /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:$1" "$HOTKEYS_PLIST" 2>/dev/null
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:$1:enabled bool true" "$HOTKEYS_PLIST"
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:$1:value:type string standard" "$HOTKEYS_PLIST"
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:$1:value:parameters array" "$HOTKEYS_PLIST"
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:$1:value:parameters:0 integer $2" "$HOTKEYS_PLIST"
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:$1:value:parameters:1 integer $3" "$HOTKEYS_PLIST"
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:$1:value:parameters:2 integer $4" "$HOTKEYS_PLIST"
}

# Screenshots (values captured live from System Settings - real verified
# parameters, not computed from a keycode table)
set_hotkey 28  51 20 1179648   # Save picture of screen as a file           - Shift+Cmd+3
set_hotkey 29  51 20 1441792   # Copy picture of screen to clipboard        - Ctrl+Shift+Cmd+3
set_hotkey 30  52 21 1179648   # Save picture of selected area as a file    - Shift+Cmd+4
set_hotkey 31  52 21 1441792   # Copy picture of selected area to clipboard - Ctrl+Shift+Cmd+4
set_hotkey 184 53 23 1179648   # Screenshot and recording options           - Shift+Cmd+5

# Windows: cycle through windows of the front app (values from this
# machine's original, pre-sweep configuration)
set_hotkey 27 96 50 1048576    # Move focus to next window in application   - Cmd+`

###############################################################################
# Apply
###############################################################################

killall Dock
killall Finder
killall cfprefsd

# Writing com.apple.symbolichotkeys directly (not through System Settings'
# own UI) doesn't make the OS rebind the actual key handlers - this private
# tool forces an immediate rebind so the Keyboard Shortcuts changes above
# take effect now instead of at next login.
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

echo "Done. Some changes may need a logout/restart to take effect."
