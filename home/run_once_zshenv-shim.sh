#!/usr/bin/env bash
# run_once_zshenv-shim.sh
# Creates or patches the untracked ~/.config/zsh/.zshenv shim (sourcing
# the chezmoi-tracked managed.zshenv).
#
# Why untracked: personal / local-machine tooling exports (e.g. agent tooling,
# private endpoints) live directly in .zshenv without polluting tracked dotfiles.
# So managed.zshenv holds the deliberate tracked environment config, and .zshenv
# stays a local shim outside chezmoi (see the .config/zsh/.zshenv entry in
# .chezmoiignore).
#
# If .zshenv does not exist, creates it with the source line; if it already
# exists but lacks the source line, appends it (idempotent, preserves existing
# content). Otherwise no-op.

set -euo pipefail

mkdir -p "$HOME/.config/zsh"

ZSHENV="$HOME/.config/zsh/.zshenv"

if [ ! -f "$ZSHENV" ]; then
    # shellcheck disable=SC2016  # literal string with variable ref intended for file
    printf '%s\n' 'source "$ZDOTDIR/managed.zshenv"' > "$ZSHENV"
    echo "Created $ZSHENV (shim sourcing managed.zshenv)."
elif
    # shellcheck disable=SC2016  # literal string with variable ref intended for file
    ! grep -qF 'source "$ZDOTDIR/managed.zshenv"' "$ZSHENV"; then
    # shellcheck disable=SC2016  # literal string with variable ref intended for file
    printf '%s\n' 'source "$ZDOTDIR/managed.zshenv"' >> "$ZSHENV"
    echo "Appended source line to $ZSHENV."
fi
