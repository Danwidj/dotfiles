# Raycast Configuration (`dot_config/raycast/`)

Houses settings for [Raycast](https://www.raycast.com/), the extensible launcher and productivity tool for macOS.

### Files

- **`private_raycast-export.rayconfig`**: An encrypted settings export covering custom hotkeys, window management configurations, quicklinks, and script commands.
- **`scripts/`**: Maps to `~/.config/raycast/scripts/`. Raycast script commands:
  - **`dummy-file.sh`** ("Dummy File"): creates a small text, PDF or PNG file in `~/.cache/dummy-files/` and reveals it in Finder, ready to drag into an upload field.

> **Script Note**: Raycast only loads script commands from folders it has been told about. Once per machine, open **Raycast → Settings → Extensions → + → Add Script Directory** and select `~/.config/raycast/scripts`.

> **Import Note**: Raycast settings cannot be injected directly via files while Raycast is running. After bootstrapping, open **Raycast → Settings → Advanced → Import** and select `~/.config/raycast/raycast-export.rayconfig`, entering your export passphrase from your password manager.
