# Neovim Core Configuration (`dot_config/nvim/lua/config/`)

Contains core configuration files evaluated by LazyVim.

### Files

- **`private_keymaps.lua`**: Custom keymaps: black-hole register routing for deletes and changes to preserve clipboard, visual paste register preservation (`v_P`), and `<D-a>` (Cmd+A) whole buffer selection.
- **`private_options.lua`**: Vim options (`opt`), tab widths, clipboard settings, line numbers, and search preferences.
- **`private_lazy.lua`**: Initializes the `lazy.nvim` plugin manager, sets import paths, and configures update checking.
