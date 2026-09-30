# GitHub Actions Workflows

This directory contains continuous integration (CI) workflows for the dotfiles repository:

- **`ci.yaml`**: Cross-platform verification running on `ubuntu-latest`. Sets up tools via `jdx/mise-action`, initializes chezmoi, applies non-OS-specific configurations with `--exclude=scripts`, and executes the Bats test suite.
- **`lint.yaml`**: Automated shell script linting via [ShellCheck](https://www.shellcheck.net/) across all `home/.chezmoiscripts/run_*.sh` and `mise-tasks/**` files via `mise run lint`.
- **`macos-ci.yaml`**: macOS-specific workflow running on `macos-latest`. Sets up tools via `jdx/mise-action`, validates full chezmoi application via `mise run ci:apply`, and runs macOS-targeted Bats tests via `mise run test`.
