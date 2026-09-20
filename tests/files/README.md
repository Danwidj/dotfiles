# Bats Test Cases

This directory contains test definitions executed by Bats:

- **`common.bats`**: Verifies cross-platform configurations: validates that `managed.zsh`, `init.lua`, `tmux.conf`, `config.ghostty`, and `starship.toml` exist after apply, checks Zsh syntax and plugin order, and tests idempotency of `run_once_zshrc.sh`.
- **`data.bats`**: Tests Go template rendering for dynamic files (`dot_config/git/private_config.tmpl` and `dot_config/homebrew/private_Brewfile.tmpl`) across different variables (`machine_type` = personal vs work, custom emails).
- **`macos.bats`**: Validates existence, executable permissions, and bash syntax parsing of macOS provisioning scripts (`run_once_macos.sh` and `run_once_install-packages.sh`).
