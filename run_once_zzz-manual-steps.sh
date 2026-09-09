#!/usr/bin/env bash
# Manual setup steps that can't be scripted (binary plists, GUI-only settings).
# Runs last (zzz- prefix) so it appears after every other run_once script.

cat <<'EOF'

===============================================================================
MANUAL SETUP REQUIRED
===============================================================================
The following can't be automated — please do them now, then press Enter:

Finder:
  - Settings > Sidebar (Cmd+,):
      Recents:      ON
      Shared:       OFF
      Favourites:   Desktop ON only (all others OFF)
      Locations:    iCloud Drive ON, Cloud Storage ON, [home folder] ON,
                    External Disks ON — everything else OFF
      Bin:          ON
  - Drag ~/workspace into the sidebar, below Desktop
  - In any Finder window: Cmd+J on Recents, set view to List

Raycast:
  - Install extensions/plugins manually (no CLI install path exists)
  - Import settings: Settings > Advanced > Import > select
    ~/.config/raycast/raycast-export.rayconfig > enter the export
    passphrase (in password manager, never tracked in this repo).
    Raycast now covers window management (was Rectangle) and
    keep-awake/menu-bar utilities (was Vorssaint) - both removed.

===============================================================================
EOF

read -r -p "Press Enter once done (or to skip): " _

# Auto-launch Ghostty as the new default terminal. This does NOT close the
# current terminal — that process can't cleanly close its own parent shell.
if [ -d "/Applications/Ghostty.app" ]; then
    open -a Ghostty
fi
