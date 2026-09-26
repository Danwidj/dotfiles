# Mise Configuration (`dot_config/mise/`)

Houses settings for [mise](https://mise.jdx.dev/) (formerly rtx), the polyglot developer tool and runtime version manager.

### Files

- **`config.toml`**: Maps to `~/.config/mise/config.toml`. Defines default runtime versions (Node 22, UV, Go, Java), tool aliases, and postinstall hooks (e.g. setting global npm cache and logs directories to XDG compliance).
