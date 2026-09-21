# `~/.config` Directory (`dot_config/`)

This directory represents the XDG base directory (`$XDG_CONFIG_HOME`, typically `~/.config/`).

### Directly Contained Files

- **`private_starship.toml`**: Target `~/.config/starship.toml`. Configures the cross-shell Starship prompt with Catppuccin theme styling and custom modules for git status, language versions, and directory display.

### Subdirectories

Subdirectories under `dot_config/` hold configurations for individual tools (AeroSpace, GitHub CLI, Ghostty, Git, herdr, Homebrew, mise, Neovim, Raycast, tmux, UV, and Zsh). Each has its own dedicated directory and README.

The `fzf/` directory contains fzf appearance and picker options sourced by the
Zsh configuration.

The `uv/` directory contains the tracked manifest for globally installed Python
CLI tools. `run_onchange_install-uv-tools.sh` installs these tools whenever the
manifest changes.

Common package-manager caches use `~/.cache` through XDG defaults or explicit
tool settings, including npm, uv, pip, Hugging Face, and Go. Maven and Gradle
state are stored under `~/.local/share`.
Matplotlib's user configuration and font cache are stored under
`~/.config/matplotlib`.

Claude Code and Pi Coding Agent are also configured to keep their global state
under `~/.config` through `CLAUDE_CONFIG_DIR` and `PI_CODING_AGENT_DIR`.
