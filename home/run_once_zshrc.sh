#!/usr/bin/env bash
# run_once_zshrc.sh
# Creates or patches the untracked ~/.config/zsh/.zshrc shim (one line sourcing
# the chezmoi-tracked managed.zshrc).
#
# Why untracked: installers (nvm, pyenv, conda-style, etc.) auto-append lines
# directly into .zshrc. If chezmoi managed .zshrc, every installer edit would
# drift/collide with the tracked source. So managed.zshrc holds the deliberate
# config, and .zshrc stays an installer-writable shim outside chezmoi
# (see the .config/zsh/.zshrc entry in .chezmoiignore).
#
# If .zshrc does not exist, creates it with the source line; if it already
# exists with the legacy managed.zsh source line, replaces it with managed.zshrc;
# if it exists but lacks the source line, appends it (idempotent, preserves existing
# content). Otherwise no-op.

set -euo pipefail

# Ensure zsh history directory exists (XDG-compliant)
mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/zsh"

ZSHRC="$HOME/.config/zsh/.zshrc"

if [ ! -f "$ZSHRC" ]; then
    # shellcheck disable=SC2016  # literal string with variable ref intended for file
    printf '%s\n' 'source "$ZDOTDIR/managed.zshrc"' > "$ZSHRC"
    echo "Created $ZSHRC (shim sourcing managed.zshrc)."
elif
    # shellcheck disable=SC2016  # literal string with variable ref intended for file
    grep -qF 'source "$ZDOTDIR/managed.zsh"' "$ZSHRC"; then
    TMP_ZSHRC=$(mktemp "${ZSHRC}.XXXXXX")
    # shellcheck disable=SC2016  # literal string with variable ref intended for file
    sed 's|source "\$ZDOTDIR/managed\.zsh"|source "$ZDOTDIR/managed.zshrc"|g' "$ZSHRC" > "$TMP_ZSHRC"
    mv "$TMP_ZSHRC" "$ZSHRC"
    echo "Replaced managed.zsh with managed.zshrc in $ZSHRC."
elif
    # shellcheck disable=SC2016  # literal string with variable ref intended for file
    ! grep -qF 'source "$ZDOTDIR/managed.zshrc"' "$ZSHRC"; then
    # shellcheck disable=SC2016  # literal string with variable ref intended for file
    printf '%s\n' 'source "$ZDOTDIR/managed.zshrc"' >> "$ZSHRC"
    echo "Appended source line to $ZSHRC."
fi
