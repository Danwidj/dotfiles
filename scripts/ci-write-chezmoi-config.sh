#!/usr/bin/env bash
# Write a chezmoi config with CI-safe template data, shared by ci.yaml and
# macos-ci.yaml.

set -euo pipefail

mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml <<'EOF'
[data]
    machine_type = "personal"
    email = "ci@example.com"
EOF
