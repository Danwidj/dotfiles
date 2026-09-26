# Zsh Shell Configuration (`dot_config/zsh/`)

Houses the interactive Zsh configuration with relocated `$ZDOTDIR`.

### Files

- **`private_dot_zshenv`**: Maps to `~/.config/zsh/.zshenv`. Sourced by every Zsh invocation (interactive or not, login or not). Sets core XDG base directories, ensures `$XDG_RUNTIME_DIR` exists, sources `managed.zshenv`, and sets `CLICOLOR`/`LSCOLORS`.
- **`private_managed.zshenv`**: Maps to `~/.config/zsh/managed.zshenv`. Sourced by `.zshenv` to export environment variables for all shells without running heavy commands, plugins, or interactive shell options (e.g. XDG redirects for tools like Copilot, Claude, Docker, Go, Gradle, etc.).
- **`private_managed.zsh`**: Maps to `~/.config/zsh/managed.zsh`. Fully tracked interactive shell configuration managing:
  - `PATH` export (kept here because macOS `/etc/zprofile` `path_helper` reorders `PATH` set in `.zshenv`).
  - Sensible Zsh options (history control, globbing, directory navigation).
  - Strict plugin loading order: `compinit` → `fzf-tab` → `zsh-autosuggestions` → `zsh-syntax-highlighting`.
  - Prompt initialization via [Starship](https://starship.rs/).
  - Shell history sync via [Atuin](https://atuin.sh/).
  - [fzf](https://github.com/junegunn/fzf) keybindings and Catppuccin Mocha/Latte color themes.

### Untracked Shims

- **`~/.config/zsh/.zshrc`**: An untracked, one-line shim sourcing `managed.zsh`, created on initial setup by `run_once_zshrc.sh` if missing. This pattern prevents external installers (e.g. tool managers appending `export PATH=...`) from conflicting with chezmoi's tracked configuration.
