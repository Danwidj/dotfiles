# VS Code User Configuration (`private_Library/.../User/`)

Houses editor preferences and keybindings for Visual Studio Code on macOS (`~/Library/Application Support/Code/User/`).

### Files

- **`settings.json`**: Editor preferences including theme settings (Catppuccin), font family, format-on-save, telemetry disabling, and language-specific formatters.
- **`private_keybindings.json`**: Custom keyboard shortcuts aligned with modal and navigation workflows.

Extension installations are handled declaratively via `home/run_onchange_install-vscode-extensions.sh`.
