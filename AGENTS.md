# Project agent memory

This file is the project's committed home for project-intrinsic agent knowledge: build, test, release, architecture, and sharp-edge notes that should travel with the code.

- Add durable project-specific notes here as they are discovered through real work.
- Chezmoi's managed source root is `home/`, not the repo root: a root `.chezmoiroot` file (containing `home`) tells chezmoi to treat `home/` as the source state, so `.chezmoi.toml.tmpl`, `.chezmoiignore.tmpl`, `dot_config/`, `private_Library/`, and every `run_once_*`/`run_onchange_*`/`run_after_*` script live under `home/`. Repo tooling (`.github/`, `tests/`, `scripts/`, `Makefile`, `README.md`) stays at the repo root and is never applied to `$HOME`. `chezmoi init/apply/diff --source=.` still works unchanged from the repo root — chezmoi auto-detects `.chezmoiroot` regardless of how the source path was passed. Any new chezmoi-managed file must go under `home/`; anything meant to stay repo tooling must NOT go under `home/`.
- Bats tests under `tests/files/*.bats` reach into chezmoi-managed content via raw filesystem paths (not through chezmoi's own root resolution), so those paths need the `home/` segment (e.g. `${BATS_TEST_DIRNAME}/../../home/dot_config/...`) — but the `--source="${BATS_TEST_DIRNAME}/../.."` argument passed to `chezmoi init --apply` itself does NOT need a `/home` suffix, since chezmoi resolves that automatically.
- `scripts/lint.sh` finds run scripts via `git ls-files 'home/run_*.sh'` — keep this glob in sync if the source root ever moves again.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
