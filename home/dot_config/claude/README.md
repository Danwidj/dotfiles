# Claude Code Configuration (`dot_config/claude/`)

Houses user-scope configuration and memory instructions for [Claude Code](https://code.claude.com/).

### Files

- **`private_CLAUDE.md`**: Maps to `~/.config/claude/CLAUDE.md`. Contains an import directive (`@~/.config/agents/AGENTS.md`) loading the canonical shared agent instructions into Claude Code without interactive prompts.
- **`modify_private_settings.json`**: chezmoi modify script updating `statusLine` in `~/.config/claude/settings.json` to use `~/.config/statusline/statusline.sh`, while preserving all other Claude Code settings and hooks.
