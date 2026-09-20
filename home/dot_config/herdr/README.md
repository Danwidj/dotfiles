# Herdr Configuration (`dot_config/herdr/`)

Houses settings for [herdr](https://github.com/Danwidj/dotfiles), the AI agent session restore and workspace manager.

### Files

- **`private_config.toml`**: Maps to `~/.config/herdr/config.toml`. Configures session restore options, agent hooks (such as auto-resuming Claude and Pi sessions), and workspace preferences. Integrations are automatically maintained by `home/run_after_install-herdr-integrations.sh`.
