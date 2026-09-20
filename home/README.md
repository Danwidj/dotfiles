# chezmoi Source Root (`home/`)

This directory is the source root for chezmoi, defined by the root `.chezmoiroot` file. Everything here represents the target state destined for `$HOME`.

> **Note**: This `README.md` and all nested `README.md` files are ignored by `home/.chezmoiignore.tmpl` so they are never copied into `$HOME`.

### Contents

- **`.chezmoi.toml.tmpl`**: Prompts for machine-specific configuration variables (`machine_type`, `email`) on first `init`.
- **`.chezmoiignore.tmpl`**: Patterns for files and directories that chezmoi should not manage or apply.
- **`dot_config/`**: Maps to `~/.config/`, containing tool and application configurations.
- **`private_Library/`**: Maps to `~/Library/` on macOS, containing user settings (e.g. VS Code configuration).
- **`run_once_*.sh`**: One-time provisioning scripts executed on initial `chezmoi apply` (Homebrew packages, macOS system defaults, Zsh environment setup, and manual checklist prompts).
- **`run_onchange_*.sh`**: Scripts executed whenever their dependent content hashes change (such as `run_onchange_install-vscode-extensions.sh`).
- **`run_after_*.sh`**: Scripts executed after configurations have been applied to disk (such as `run_after_install-herdr-integrations.sh`).
