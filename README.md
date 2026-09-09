# dotfiles

Personal macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## What's managed

- **zsh** - `~/.config/zsh` shell config (`ZDOTDIR`-relocated), plus `.zshrc`
- **nvim** - LazyVim-based Neovim config (`~/.config/nvim`) - only customizations are tracked, not the LazyVim starter boilerplate (see "nvim setup" below)
- **tmux** - config and themes (`~/.config/tmux`)
- **ghostty** - terminal config (`~/.config/ghostty`)
- **starship** - prompt config (`~/.config/starship.toml`)
- **git** - `~/.gitconfig` (templated with per-machine email)
- **Homebrew** - packages tracked in `~/.Brewfile`, installed via `brew bundle`
- **VSCode** - extension list, installed on change
- **macOS defaults** - system preference tweaks, including default app handlers (browser/PDF/mail/image/text/calendar/video/archive) via `duti`

## Install on a new machine

```sh
chezmoi init --apply Danwidj/dotfiles
```

First apply will prompt for `machine_type` (personal/work) and git email, then run, in order:

1. `run_once_install-packages.sh` - installs Homebrew + Xcode CLT if missing, then `brew bundle` from `~/.Brewfile`
2. `run_once_macos.sh` - applies macOS system defaults, then sets default app handlers (browser, PDF, mail, images, text, calendar, video, archive) via `duti`
3. `run_once_zshenv.sh` - points `/etc/zshenv` at `ZDOTDIR`
4. `run_onchange_install-vscode-extensions.sh` - installs VSCode extensions (reruns when the extension list changes)
5. `run_once_zzz-manual-steps.sh` - prints manual (non-scriptable) setup steps and pauses for confirmation before continuing
6. `run_once_after_vorssaint-restore.sh` - restores Vorssaint preferences from the managed plist (runs after all other `run_once_` scripts, per chezmoi's `run_once_after_` ordering)

## nvim setup

Only the actual customizations under `~/.config/nvim` are chezmoi-managed (`lazyvim.json`, `lazy-lock.json`, `lua/config/{options,keymaps,autocmds}.lua`, `lua/plugins/*.lua`). The stock LazyVim starter boilerplate (`init.lua`, `lua/config/lazy.lua`, `.gitignore`, `README.md`, `LICENSE`, `stylua.toml`, `lua/plugins/example.lua`) is intentionally untracked, since it's identical to a fresh `LazyVim/starter` checkout and would just be dead weight in this repo.

On a new machine, get the starter base in place *before* `chezmoi apply` overlays the customizations:

```sh
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
chezmoi apply
```

(`chezmoi init --apply` runs the full bootstrap already, but nvim's dotfiles only overlay on top of an existing starter checkout - if `~/.config/nvim` doesn't exist yet, clone the starter first, then re-run `chezmoi apply` to lay the customizations on top.)

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
- `nvim/` no longer carries LazyVim's upstream `README.md`/`LICENSE`/boilerplate (untracked as pure starter boilerplate); this file is the top-level dotfiles README only. See "nvim setup" above for new-machine bootstrap.
- **Local-overlay pattern** - `custom.zsh`, `Brewfile.local`, and `extensions.local` are untracked, machine-specific overlays (gitignored via `.chezmoiignore`). `run_once_`/`run_onchange_` scripts re-trigger by hashing their own *tracked* source file, not these untracked overlay files, so editing an overlay alone won't retrigger its script via `chezmoi apply`. Either re-run the script manually after editing the overlay, or touch/edit the tracked script itself so `chezmoi apply` picks it up.
