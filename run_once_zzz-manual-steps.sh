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

Ghostty:
  - Open it once manually and set as default terminal if desired
    (chezmoi does not launch apps or close your current terminal)

===============================================================================
EOF

read -r -p "Press Enter once done (or to skip): " _
