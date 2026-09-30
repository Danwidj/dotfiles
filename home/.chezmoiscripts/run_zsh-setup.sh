#!/usr/bin/env bash
# run_zsh-setup.sh
# Sets up ZDOTDIR in /etc/zshenv, ensures untracked ~/.config/zsh/.zshenv and
# ~/.config/zsh/.zshrc shims source managed configs as their first line, and
# ensures the XDG-compliant zsh directory exists.
#
# Runs on every chezmoi apply to guarantee the source lines stay at line 1 even
# if external installers append content.

set -euo pipefail

# 1. If /etc/zshenv lacks ZDOTDIR, append the export via sudo tee -a
ETC_ZSHENV="${ETC_ZSHENV:-/etc/zshenv}"
if ! grep -q "ZDOTDIR" "$ETC_ZSHENV" 2>/dev/null; then
    # shellcheck disable=SC2016  # literal string with variable ref intended for file
    line='export ZDOTDIR="$HOME/.config/zsh"'
    if [ "$ETC_ZSHENV" = "/etc/zshenv" ]; then
        echo "$line" | sudo tee -a "$ETC_ZSHENV" >/dev/null
    else
        mkdir -p "$(dirname "$ETC_ZSHENV")"
        echo "$line" >> "$ETC_ZSHENV"
    fi
fi

# 2. Ensure untracked shims exist and have the source line on line 1
mkdir -p "$HOME/.config/zsh"

ensure_shim() {
    local file="$1"
    local target_line="$2"

    if [ ! -f "$file" ]; then
        mkdir -p "$(dirname "$file")"
        printf '%s\n' "$target_line" > "$file"
        return
    fi

    local first_line count
    first_line=$(head -n 1 "$file" 2>/dev/null || true)
    count=$(grep -cFx "$target_line" "$file" 2>/dev/null || true)

    if [ "$count" -eq 1 ] && [ "$first_line" = "$target_line" ]; then
        return
    fi

    local tmp
    tmp=$(mktemp "${file}.XXXXXX")
    printf '%s\n' "$target_line" > "$tmp"
    grep -vFx "$target_line" "$file" >> "$tmp" || true
    mv "$tmp" "$file"
}

# shellcheck disable=SC2016  # literal string with variable ref intended for file
ensure_shim "$HOME/.config/zsh/.zshenv" 'source "$ZDOTDIR/managed.zshenv"'
# shellcheck disable=SC2016  # literal string with variable ref intended for file
ensure_shim "$HOME/.config/zsh/.zshrc" 'source "$ZDOTDIR/managed.zshrc"'

# 3. Ensure zsh data directory exists (XDG-compliant)
mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
