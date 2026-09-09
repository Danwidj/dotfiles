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
defaults write com.apple.dock wvous-tr-corner -int 1          # off
defaults write com.apple.dock wvous-bl-corner -int 10         # Sleep Display
defaults write com.apple.dock wvous-br-corner -int 1          # off
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-modifier -int 1048576  # Command required
defaults write com.apple.dock wvous-br-modifier -int 0
# Desktop: triggered via Raycast hotkey (right-side hot corners unreachable with vertical monitor)

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
    set_default() {
        local bundle_id="$1" uti_or_ext="$2" role="${3:-all}"
        if duti -s "$bundle_id" "$uti_or_ext" "$role" 2>/dev/null; then
            echo "Set $bundle_id as handler for $uti_or_ext ($role)"
        else
            echo "Warning: could not set $bundle_id as handler for $uti_or_ext (app likely not installed) - skipping"
        fi
    }

    # `duti -s <bundle_id> <url_scheme>` (2 args, NO role) for URL schemes.
    # Passing a 3rd arg here makes duti misinterpret the scheme as a UTI
    # string instead (resolves to a bogus dyn.* UTI and fails with -50).
    set_default_scheme() {
        local bundle_id="$1" scheme="$2"
        if duti -s "$bundle_id" "$scheme" 2>/dev/null; then
            echo "Set $bundle_id as handler for $scheme: URLs"
        else
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
fi

###############################################################################
# Apply
###############################################################################

killall Dock
killall Finder
killall cfprefsd

echo "Done. Some changes may need a logout/restart to take effect."
