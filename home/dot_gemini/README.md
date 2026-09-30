# Gemini / Antigravity CLI Configuration (`dot_gemini/`)

Houses global configuration and rules for Google Antigravity CLI (`agy`) and Gemini tooling.

### Files

- **`symlink_AGENTS.md.tmpl`**: Maps to `~/.gemini/AGENTS.md`. Symlinks to `~/.config/agents/AGENTS.md` so `agy` loads canonical shared agent instructions into its global rules scope (subject to Antigravity's 24,000-byte per-file limit).
