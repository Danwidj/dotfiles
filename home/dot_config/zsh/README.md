# Zsh Shell Configuration (`dot_config/zsh/`)

Houses the interactive Zsh configuration with relocated `$ZDOTDIR`.

### Files

- **`private_managed.zshenv`**: Maps to `~/.config/zsh/managed.zshenv`. Sourced by `.zshenv` to export environment variables for all shells without running heavy commands, plugins, or interactive shell options (e.g. core XDG base directories, `$XDG_RUNTIME_DIR`, `CLICOLOR`/`LSCOLORS`, and tool redirects for Copilot, Claude, Docker, Go, Gradle, Vim, etc.).
- **`private_managed.zshrc`**: Maps to `~/.config/zsh/managed.zshrc`. Fully tracked interactive shell configuration managing:
  - `PATH` export (kept here because macOS `/etc/zprofile` `path_helper` reorders `PATH` set in `.zshenv`).
  - Sensible Zsh options (history control, globbing, directory navigation).
  - Strict plugin loading order: `compinit` → `fzf-tab` → `zsh-autosuggestions` → `zsh-syntax-highlighting`.
  - Prompt initialization via [Starship](https://starship.rs/).
  - Shell history sync via [Atuin](https://atuin.sh/).
  - [fzf](https://github.com/junegunn/fzf) keybindings and Catppuccin Mocha/Latte color themes.

### Untracked Shims

- **`~/.config/zsh/.zshenv`**: An untracked shim sourcing `managed.zshenv`, maintained by `run_zsh-setup.sh` so `source "$ZDOTDIR/managed.zshenv"` always remains on line 1. This pattern allows machine-local / agent tooling exports to live outside tracked dotfiles.
- **`~/.config/zsh/.zshrc`**: An untracked shim sourcing `managed.zshrc`, maintained by `run_zsh-setup.sh` so `source "$ZDOTDIR/managed.zshrc"` always remains on line 1. This pattern prevents external installers (e.g. tool managers appending `export PATH=...`) from conflicting with chezmoi's tracked configuration.
