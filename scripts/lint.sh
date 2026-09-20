#!/usr/bin/env bash
# Lint all run_*.sh scripts with shellcheck

set -euo pipefail

# Find all run_*.sh scripts tracked by git
scripts=$(git ls-files 'run_*.sh')

if [ -z "$scripts" ]; then
    echo "No run_*.sh scripts found"
    exit 0
fi

echo "Linting shell scripts:"
echo "$scripts" | sed 's/^/  /'

# Run shellcheck on all found scripts
# shellcheck disable=SC2086  # scripts is intentionally unquoted for word splitting
shellcheck $scripts
