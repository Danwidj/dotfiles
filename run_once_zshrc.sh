#!/usr/bin/env bash
# run_once_zshrc.sh
# Creates or patches the untracked ~/.config/zsh/.zshrc shim (one line sourcing
# the chezmoi-tracked managed.zsh).
#
# Why untracked: installers (nvm, pyenv, conda-style, etc.) auto-append lines
# directly into .zshrc. If chezmoi managed .zshrc, every installer edit would
# drift/collide with the tracked source. So managed.zsh holds the deliberate
# config, and .zshrc stays an installer-writable shim outside chezmoi
# (see the .config/zsh/.zshrc entry in .chezmoiignore).
#
# If .zshrc does not exist, creates it with the source line; if it already
# exists but lacks the source line, appends it (idempotent, preserves existing
# content). Otherwise no-op.

set -euo pipefail

ZSHRC="$HOME/.config/zsh/.zshrc"

if [ ! -f "$ZSHRC" ]; then
    printf '%s\n' 'source "$ZDOTDIR/managed.zsh"' > "$ZSHRC"
    echo "Created $ZSHRC (shim sourcing managed.zsh)."
elif ! grep -qF 'source "$ZDOTDIR/managed.zsh"' "$ZSHRC"; then
    printf '%s\n' 'source "$ZDOTDIR/managed.zsh"' >> "$ZSHRC"
    echo "Appended source line to $ZSHRC."
fi
