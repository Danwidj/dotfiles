#!/usr/bin/env bash
# run_after_setup-ssh.sh
# Ensures ~/.ssh/config exists with permissions 0600 and includes
# ~/.config/ssh/config without overwriting any existing configuration.

set -euo pipefail

SSH_DIR="${SSH_DIR:-${HOME}/.ssh}"
SSH_CONFIG="${SSH_CONFIG:-${SSH_DIR}/config}"
TARGET_LINE="Include ~/.config/ssh/config"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [ ! -f "$SSH_CONFIG" ]; then
    printf '%s\n' "$TARGET_LINE" > "$SSH_CONFIG"
    chmod 600 "$SSH_CONFIG"
else
    chmod 600 "$SSH_CONFIG"
    if ! grep -qxF "$TARGET_LINE" "$SSH_CONFIG" 2>/dev/null; then
        if [ -s "$SSH_CONFIG" ] && [ "$(tail -c 1 "$SSH_CONFIG" 2>/dev/null)" != "" ]; then
            printf '\n' >> "$SSH_CONFIG"
        fi
        printf '%s\n' "$TARGET_LINE" >> "$SSH_CONFIG"
    fi
fi
