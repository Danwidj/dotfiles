# GitHub Actions Workflows

This directory contains continuous integration (CI) workflows for the dotfiles repository:

- **`ci.yaml`**: Cross-platform verification running on `ubuntu-latest`. Initializes chezmoi, applies non-OS-specific configurations, and executes the Bats test suite.
- **`lint.yaml`**: Automated shell script linting via [ShellCheck](https://www.shellcheck.net/) across all `home/run_*.sh` and `scripts/*.sh` files.
- **`macos-ci.yaml`**: macOS-specific workflow running on `macos-latest`. Validates full chezmoi application and runs macOS-targeted Bats tests.
