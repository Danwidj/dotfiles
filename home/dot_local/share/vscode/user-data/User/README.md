# VS Code User Configuration (`dot_local/share/vscode/user-data/User/`)

Houses editor preferences and keybindings for Visual Studio Code on macOS (`~/.local/share/vscode/user-data/User/`, via VS Code Portable mode with `VSCODE_PORTABLE=~/.local/share/vscode`).

### Files

- **`private_settings.json`**: Editor preferences including theme settings (Catppuccin), font family, format-on-save, telemetry disabling, and language-specific formatters.
- **`private_keybindings.json`**: Custom keyboard shortcuts aligned with modal and navigation workflows.

Extension installations are handled declaratively via `home/run_onchange_install-vscode-extensions.sh`.