# GitHub CLI Configuration (`dot_config/gh/`)

Houses settings for the official [GitHub CLI (`gh`)](https://cli.github.com/).

### Files

- **`private_config.yml`**: Maps to `~/.config/gh/config.yml`. Configures default git protocol, editor preference, and command behavior for GitHub CLI. Ignored on `machine_type = "work"` to prevent colliding with enterprise GitHub configurations.
