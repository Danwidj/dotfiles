# GitHub Copilot CLI Configuration (`dot_local/share/copilot/`)

Houses user-scope configuration and custom instructions for GitHub Copilot CLI (routed via `$COPILOT_HOME`).

### Files

- **`symlink_copilot-instructions.md.tmpl`**: Maps to `~/.local/share/copilot/copilot-instructions.md`. Symlinks to `~/.config/agents/AGENTS.md` so Copilot CLI includes the shared instructions.
