#!/usr/bin/env bash
# run_once_zshrc.sh
# Creates the untracked ~/.config/zsh/.zshrc shim (one line sourcing the
# chezmoi-tracked managed.zsh) on fresh machines only.
#
# Why untracked: installers (nvm, pyenv, conda-style, etc.) auto-append lines
# directly into .zshrc. If chezmoi managed .zshrc, every installer edit would
# drift/collide with the tracked source. So managed.zsh holds the deliberate
# config, and .zshrc stays an installer-writable shim outside chezmoi
# (see the .config/zsh/.zshrc entry in .chezmoiignore).
#
# Never touches an existing .zshrc: on a machine that already has one (with
# installer-injected lines already in it), this script is a complete no-op.

set -euo pipefail

ZSHRC="$HOME/.config/zsh/.zshrc"

[ -f "$ZSHRC" ] || {
    printf '%s\n' 'source "$ZDOTDIR/managed.zsh"' > "$ZSHRC"
    echo "Created $ZSHRC (shim sourcing managed.zsh)."
}
