#!/usr/bin/env bash
# Installs globally available Python CLI tools listed in ~/.config/uv/tools.txt.
# Re-runs whenever the tracked tool manifest changes.

set -euo pipefail

if ! command -v uv >/dev/null 2>&1; then
    echo "Error: uv is required to install tracked uv tools." >&2
    exit 1
fi

TOOLS_FILE="${XDG_CONFIG_HOME:-"$HOME/.config"}/uv/tools.txt"

if [[ ! -f "$TOOLS_FILE" ]]; then
    echo "Error: uv tool manifest not found: $TOOLS_FILE" >&2
    exit 1
fi

while IFS= read -r tool || [[ -n "$tool" ]]; do
    tool="${tool#"${tool%%[![:space:]]*}"}"
    tool="${tool%"${tool##*[![:space:]]}"}"

    if [[ -z "$tool" || "$tool" == \#* ]]; then
        continue
    fi

    echo "Installing uv tool: $tool"
    uv tool install --force "$tool"
done < "$TOOLS_FILE"
