#!/usr/bin/env bash
# Lint all run_*.sh, run_*.sh.tmpl scripts and scripts/*.sh scripts with shellcheck

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Find all run_*.sh scripts and CI/tooling scripts tracked by git
scripts=$(git -C "$ROOT_DIR" ls-files 'home/.chezmoiscripts/run_*.sh' 'scripts/*.sh')
tmpl_scripts=$(git -C "$ROOT_DIR" ls-files 'home/.chezmoiscripts/run_*.sh.tmpl')

if [ -z "$scripts" ] && [ -z "$tmpl_scripts" ]; then
    echo "No scripts found to lint"
    exit 0
fi

echo "Linting shell scripts:"
if [ -n "$scripts" ]; then
    echo "  ${scripts//$'\n'/$'\n  '}"
fi
if [ -n "$tmpl_scripts" ]; then
    echo "  ${tmpl_scripts//$'\n'/$'\n  '}"
fi

target_scripts=()
if [ -n "$scripts" ]; then
    while IFS= read -r line; do
        [ -n "$line" ] && target_scripts+=("$ROOT_DIR/$line")
    done <<< "$scripts"
fi

tmp_dir=""
if [ -n "$tmpl_scripts" ]; then
    if command -v chezmoi >/dev/null 2>&1; then
        tmp_dir=$(mktemp -d)
        trap 'rm -rf "$tmp_dir"' EXIT
        while IFS= read -r tmpl; do
            [ -z "$tmpl" ] && continue
            rendered="$tmp_dir/$(basename "${tmpl%.tmpl}")"
            chezmoi execute-template --source="$ROOT_DIR" --override-data '{"machine_type": "personal", "email": "lint@example.com"}' < "$ROOT_DIR/$tmpl" > "$rendered"
            target_scripts+=("$rendered")
        done <<< "$tmpl_scripts"
    else
        while IFS= read -r tmpl; do
            [ -n "$tmpl" ] && target_scripts+=("$ROOT_DIR/$tmpl")
        done <<< "$tmpl_scripts"
    fi
fi

# Run shellcheck on all found/rendered scripts
shellcheck "${target_scripts[@]}"
