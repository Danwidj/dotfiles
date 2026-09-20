# Git Configuration (`dot_config/git/`)

Houses global Git settings, ignored patterns, and diff/pager integration.

### Files

- **`private_config.tmpl`**: Maps to `~/.config/git/config`. Go template dynamically injecting the configured user email based on machine prompt (`personal` vs `work`). Configures aliases, default branch (`main`), pull rebase behavior, and delta pager integration.
- **`private_ignore`**: Maps to `~/.config/git/ignore`. Global gitignore for OS artifacts (`.DS_Store`, `Thumbs.db`), editor states, and transient directories.
- **`private_executable_delta-theme-wrapper`**: Executable helper script that invokes [delta](https://github.com/dandavison/delta) with the appropriate Catppuccin theme (Mocha or Latte) based on current terminal styling.
