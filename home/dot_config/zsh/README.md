# Zsh Shell Configuration (`dot_config/zsh/`)

Houses the interactive Zsh configuration with relocated `$ZDOTDIR`.

### Files

- **`private_managed.zshenv`**: Maps to `~/.config/zsh/managed.zshenv`. Sourced by `.zshenv` to export environment variables for all shells without running heavy commands, plugins, or interactive shell options (e.g. core XDG base directories, `$XDG_RUNTIME_DIR`, `CLICOLOR`/`LSCOLORS`, and tool redirects for Copilot, Claude, Docker, Go, Gradle, etc.).
- **`private_managed.zshrc`**: Maps to `~/.config/zsh/managed.zshrc`. Fully tracked interactive shell configuration managing:
  - `PATH` export (kept here because macOS `/etc/zprofile` `path_helper` reorders `PATH` set in `.zshenv`).
  - Sensible Zsh options (history control, globbing, directory navigation).
  - Activation of prompt ([Starship](https://starship.rs/)), runtime manager ([mise](https://mise.jdx.dev/)), and directory jumper ([zoxide](https://github.com/ajeetdsouza/zoxide)).
  - Modular sourcing loop loading `conf.d/*.zsh` in numerical order.
- **`conf.d/`**: Maps to `~/.config/zsh/conf.d/`. Modular configuration snippets loaded in order:
  - **`private_00-plugins.zsh`**: Zinit self-bootstrapping, completion system caching (`compinit`), strict plugin load ordering (`zsh-completions` → `zsh-vi-mode` → `fzf-tab` → `zinit cdreplay` → `zsh-autopair` → turbo-loaded `zsh-autosuggestions` & `zsh-syntax-highlighting`).
  - **`private_01-aliases.zsh`**: Interactive shell aliases (`vim`, `ls`, `top`, `cat`).
  - **`private_02-fzf.zsh`**: fzf shell integration and full-screen reverse layout, fzf-tab options and contextual previews (`eza` for directories, `bat --theme=ansi` for files).
  - **`private_03-atuin.zsh`**: SQLite-backed history sync and full-screen search via [Atuin](https://atuin.sh/).

### Untracked Shims

- **`~/.config/zsh/.zshenv`**: An untracked shim sourcing `managed.zshenv`, maintained by `run_zsh-setup.sh` so `source "$ZDOTDIR/managed.zshenv"` always remains on line 1. This pattern allows machine-local / agent tooling exports to live outside tracked dotfiles.
- **`~/.config/zsh/.zshrc`**: An untracked shim sourcing `managed.zshrc`, maintained by `run_zsh-setup.sh` so `source "$ZDOTDIR/managed.zshrc"` always remains on line 1. This pattern prevents external installers (e.g. tool managers appending `export PATH=...`) from conflicting with chezmoi's tracked configuration.
