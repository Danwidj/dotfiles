# Repository Tasks & CI Tooling

This directory contains standalone file task scripts for mise and CI runner setup. These tasks are kept outside of `home/` so that chezmoi never installs them into `$HOME`.

- **`lint`**: Runs `shellcheck` across all tracked shell scripts (`home/.chezmoiscripts/run_*.sh` and `mise-tasks/**`). Invoked locally with `mise run lint`.
- **`ci/apply`**: Executes `chezmoi init --apply` under sandboxed CI conditions (`mise run ci:apply`).
- **`ci/install-homebrew`**: Installs Homebrew non-interactively in Linux CI runners (`mise run ci:install-homebrew`).
- **`ci/write-chezmoi-config`**: Generates a chezmoi configuration (`chezmoi.toml`) with CI dummy data for non-interactive test runs (`mise run ci:write-chezmoi-config`).
