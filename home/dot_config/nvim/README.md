# Neovim Configuration (`dot_config/nvim/`)

Houses the Neovim editor configuration, based on [LazyVim](https://lazyvim.github.io/).

### Files

- **`private_init.lua`**: Main entrypoint initializing `lazy.nvim` and loading LazyVim specs.
- **`private_lazyvim.json`**: LazyVim state file recording enabled extras.
- **`private_lazy-lock.json`**: Plugin lockfile for reproducible plugin versions across installations.
- **`private_stylua.toml`**: Code formatting rules for Lua files.
- **`private_dot_neoconf.json`**: Project-local LSP and formatting configuration.

### Subdirectories

- **`lua/config/`**: Core Neovim setup (options, keymaps, autocmds, lazy setup).
- **`lua/plugins/`**: Custom plugin specs and LazyVim overrides (LSPs, theme, file management).
