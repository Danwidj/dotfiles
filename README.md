# dotfiles

Personal macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## What's managed

- **zsh** - `~/.config/zsh` shell config (`ZDOTDIR`-relocated), plus `.zshrc`
- **nvim** - LazyVim-based Neovim config (`~/.config/nvim`)
- **tmux** - config and themes (`~/.config/tmux`)
- **ghostty** - terminal config (`~/.config/ghostty`)
- **starship** - prompt config (`~/.config/starship.toml`)
- **git** - `~/.gitconfig` (templated with per-machine email)
- **Homebrew** - packages tracked in `~/.Brewfile`, installed via `brew bundle`
- **VSCode** - extension list, installed on change
- **macOS defaults** - system preference tweaks

## Install on a new machine

```sh
chezmoi init --apply Danwidj/dotfiles
```

First apply will prompt for `machine_type` (personal/work) and git email, then run, in order:

1. `run_once_homebrew.sh` - installs Homebrew + Xcode CLT if missing
2. `run_once_macos.sh` - applies macOS system defaults
3. `run_once_packages.sh` - `brew bundle` from `~/.Brewfile`
4. `run_once_zshenv.sh` - points `/etc/zshenv` at `ZDOTDIR`
5. `run_onchange_install-vscode-extensions.sh` - installs VSCode extensions (reruns when the extension list changes)
6. `run_once_zzz-manual-steps.sh` - prints manual (non-scriptable) setup steps and pauses for confirmation before continuing

## Manual setup (not scriptable)

Printed and paused on during `run_once_zzz-manual-steps.sh` above; listed here too for reference:

- **Finder sidebar** - binary `.sfl3` files, not scriptable via `defaults`. Settings > Sidebar (Cmd+,): Recents ON, Shared OFF, Favourites Desktop-only, Locations (iCloud Drive/Cloud Storage/home/External Disks) ON, Bin ON. Drag `~/workspace` into the sidebar below Desktop.
- **Finder Recents view** - Cmd+J in Recents, set to List.
- **Raycast extensions/plugins** - no CLI install path exists, must be added manually.

Ghostty is auto-launched (`open -a Ghostty`) at the end of `run_once_zzz-manual-steps.sh` — it does not close your original terminal, since a process can't cleanly close its own parent shell.

## Day-to-day

```sh
chezmoi edit <file>     # edit the source, not the target directly
chezmoi diff             # preview pending changes
chezmoi apply            # apply them
```

`git.autoCommit` and `git.autoPush` are on (see `.chezmoi.toml.tmpl`), so `chezmoi apply` commits and pushes source changes automatically.

## Gotchas

- Most files are `private_*` (mode 0600) since they can contain machine-specific paths or personal info.
- `.chezmoi.toml.tmpl` prompts once per machine and caches answers in `~/.config/chezmoi/chezmoi.toml` - delete that file to re-prompt.
- `nvim/` carries its own upstream `README.md`/`LICENSE` from LazyVim; this file is the top-level dotfiles README only.
