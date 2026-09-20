# Zsh Shell Configuration (`dot_config/zsh/`)

Houses the interactive Zsh configuration with relocated `$ZDOTDIR`.

### Files

- **`private_managed.zsh`**: Maps to `~/.config/zsh/managed.zsh`. Fully tracked shell configuration managing:
  - Sensible Zsh options (history control, globbing, directory navigation).
  - Strict plugin loading order: `compinit` → `fzf-tab` → `zsh-autosuggestions` → `zsh-syntax-highlighting`.
  - Prompt initialization via [Starship](https://starship.rs/).
  - Shell history sync via [Atuin](https://atuin.sh/).
  - [fzf](https://github.com/junegunn/fzf) keybindings and Catppuccin Mocha/Latte color themes.

### Untracked Shims

- **`~/.config/zsh/.zshrc`**: An untracked, one-line shim sourcing `managed.zsh`, created on initial setup by `run_once_zshrc.sh` if missing. This pattern prevents external installers (e.g. tool managers appending `export PATH=...`) from conflicting with chezmoi's tracked configuration.
