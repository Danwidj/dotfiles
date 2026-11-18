# Raycast Configuration (`dot_config/raycast/`)

Houses settings for [Raycast](https://www.raycast.com/), the extensible launcher and productivity tool for macOS.

### Files

- **`private_raycast-export.rayconfig`**: An encrypted settings export covering custom hotkeys, window management configurations, quicklinks, and script commands.
- **`scripts/`**: Maps to `~/.config/raycast/scripts/`. Raycast script commands:
  - **`dummy-file.sh`** ("Dummy File"): opens `~/.local/share/dummy-files/` in Finder in large icon view, ready to drag a dummy PDF (`dummy-13kb.pdf`, `dummy-470kb.pdf`, `dummy-1mb.pdf`, tracked under `dot_local/share/dummy-files/`) into an upload field.
  - **`chrome-incognito.sh`** ("Chrome Incognito"): opens a Chrome incognito window with the given link, or the clipboard's link when the clipboard holds exactly one, otherwise a blank window. Launch Google Chrome itself for a normal window.

> **Script Note**: Raycast only loads script commands from folders it has been told about. Once per machine, open **Raycast → Settings → Extensions → + → Add Script Directory** and select `~/.config/raycast/scripts`.

> **Import Note**: Raycast settings cannot be injected directly via files while Raycast is running. After bootstrapping, open **Raycast → Settings → Advanced → Import** and select `~/.config/raycast/raycast-export.rayconfig`, entering your export passphrase from your password manager.
