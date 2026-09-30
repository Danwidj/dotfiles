# Agent Instructions Configuration (`dot_config/agents/`)

Houses the canonical instructions file shared across coding agents and harnesses.

### Files

- **`private_AGENTS.md`**: Maps to `~/.config/agents/AGENTS.md`. Serves as the single source of truth for global agent instructions, symlinked or imported by Claude Code, OpenCode, Pi Coding Agent, Antigravity CLI (agy), and GitHub Copilot CLI.
