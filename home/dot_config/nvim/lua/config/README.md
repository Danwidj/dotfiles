# Neovim Core Configuration (`dot_config/nvim/lua/config/`)

Contains core configuration files evaluated by LazyVim.

### Files

- **`private_options.lua`**: Vim options (`opt`), tab widths, clipboard settings, line numbers, and search preferences.
- **`private_keymaps.lua`**: Custom keyboard mappings extending and overriding LazyVim defaults.
- **`private_autocmds.lua`**: Custom `autocmd` event handlers (highlight on yank, buffer cleanup, filetype rules).
- **`private_lazy.lua`**: Initializes the `lazy.nvim` plugin manager, sets import paths, and configures update checking.
