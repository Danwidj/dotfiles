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

# No pinned apps
defaults write com.apple.dock persistent-apps -array

# Tile size [default: 48]
defaults write com.apple.dock tilesize -float 46

# No recent apps [default: on]
defaults write com.apple.dock show-recents -bool false

# No running indicators [default: on]
defaults write com.apple.dock show-process-indicators -bool false

# Group windows by app in Mission Control [default: off]
defaults write com.apple.dock expose-group-apps -bool true

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

# NOTE (manual): Recents view → set to List (Cmd+J in Recents)
# NOTE (manual): Add ~/workspace to sidebar Favourites by dragging it in
#
# Sidebar items live in binary .sfl3 files — not scriptable via defaults.
# Configure manually: Finder > Settings > Sidebar (Cmd+,)
#   Recents:      ON
#   Shared:       OFF
#   Favourites:   Desktop ON only (all others OFF)
#                 then drag ~/workspace into sidebar below Desktop
#   Locations:    iCloud Drive ON, Cloud Storage ON,
#                 [home folder] ON, External Disks ON
#                 everything else OFF
#   Bin:          ON
#   Recent Tags:  OFF (scripted above)

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
# Screenshot
###############################################################################

# Enable video capture option in screenshot toolbar
defaults write com.apple.screencapture video -bool true

###############################################################################
# Apply
###############################################################################

killall Dock
killall Finder
killall cfprefsd

echo "Done. Some changes may need a logout/restart to take effect."
