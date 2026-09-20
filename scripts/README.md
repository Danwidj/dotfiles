# Repository Scripts & CI Tooling

This directory contains standalone utility scripts for CI pipelines and local repository maintenance. These scripts are kept outside of `home/` so that chezmoi never installs them into `$HOME`.

- **`lint.sh`**: Runs `shellcheck` across all tracked shell scripts (`home/run_*.sh` and `scripts/*.sh`). Invoked locally with `just lint`.
- **`ci-install-chezmoi.sh`**: Downloads and installs the chezmoi binary during CI runner setup.
- **`ci-install-homebrew.sh`**: Installs Homebrew in CI runners when required.
- **`ci-chezmoi-apply.sh`**: Executes `chezmoi init --apply` under sandboxed CI conditions.
- **`ci-write-chezmoi-config.sh`**: Generates a mock chezmoi configuration (`chezmoi.toml`) with CI dummy data for non-interactive test runs.
