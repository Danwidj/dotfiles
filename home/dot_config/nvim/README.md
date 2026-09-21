# Neovim Configuration (`dot_config/nvim/`)

This is a [LazyVim](https://www.lazyvim.org/) configuration managed by
chezmoi. The configuration is intentionally small: LazyVim supplies the
editor defaults and plugin ecosystem, while the files under `lua/plugins/`
customize completion, language servers, themes, and file browsing.

## What's included

### Core workflow

- **LazyVim + lazy.nvim**: plugin loading, defaults, update UI, and the
  `lazy-lock.json` version lockfile.
- **Snacks.nvim**: the main picker, notifications, terminal, buffer deletion,
  Git history, toggles, and other utility commands.
- **Oil.nvim**: file browser that edits directories like a buffer; hidden files
  are shown by default.
- **Which-Key**: press `<leader>` and pause to discover available commands.
- **Noice.nvim**: improved command-line, messages, and notifications.
- **Persistence.nvim**: restores the last editing session when requested.
- **Harpoon**: optional fast access to a small set of frequently used files.

### Editing and navigation

- **blink.cmp** + **friendly-snippets**: completion, snippets, signature help,
  and Super-Tab navigation.
- **mini.ai**, **mini.comment**, **mini.pairs**, and **ts-comments**: richer
  text objects, commenting, pairs, and syntax-aware comments.
- **flash.nvim**: quick jump motions.
- **yanky.nvim**: a history-aware yank and paste workflow.
- **dial.nvim**: increment and decrement dates, numbers, and other values.
- **nvim-treesitter**, **textobjects**, **context**, and **autotag**: syntax
  highlighting, structural selections, context headers, and tag completion.
- **grug-far.nvim**: project-wide search and replace.
- **inc-rename.nvim**: previewable LSP symbol renaming.

### Code intelligence and quality

- **nvim-lspconfig**, **Mason**, and **mason-lspconfig**: language-server
  installation and integration.
- **Pyrefly**: the configured Python LSP/type analyzer instead of Pyright.
- **bash-language-server**: diagnostics and navigation for `.sh` and `.bash`
  files; it is deliberately not attached to Zsh files.
- **nvim-jdtls**: Java language support from the Kotlin/Java-related setup.
- **conform.nvim**: formatting.
- **nvim-lint**: asynchronous linting.
- **trouble.nvim**: a readable workspace for diagnostics and references.
- **gitsigns.nvim**: Git changes in the sign column and hunk actions.
- **todo-comments.nvim**: searchable TODO/FIXME comments.

### Language and writing extras

The enabled LazyVim extras are:

- JSON
- Kotlin
- Markdown
- TOML
- TypeScript

Markdown additionally has **render-markdown.nvim** for in-editor rendering and
**markdown-preview.nvim** for a browser preview. **SchemaStore.nvim** supplies
JSON schemas.

### Appearance and UI

- **Catppuccin**: the active colorscheme.
- **auto-dark-mode.nvim**: switches between Catppuccin Mocha and Latte based on
  the macOS appearance.
- **lualine**, **bufferline**, **mini.icons**, **mini.hipatterns**, and
  **vim-illuminate**: statusline, buffers, icons, highlights, and word
  references.
- **render-markdown.nvim**, **nui.nvim**, and **plenary.nvim**: supporting UI
  libraries and rendered content.
- **chezmoi.nvim** and **chezmoi.vim**: editing and viewing chezmoi-managed
  files from Neovim.
- **vim-dadbod**, **vim-dadbod-ui**, and **vim-dadbod-completion**: database
  browsing and SQL completion.

The exact plugin commits are recorded in `private_lazy-lock.json`. The enabled
LazyVim extras are recorded in `private_lazyvim.json`.

## Quality-of-life shortcuts

`<leader>` is **Space**. These are the high-value shortcuts to learn first;
basic movement, search, and command-line usage are intentionally omitted.

### Find anything quickly

| Shortcut | Use |
| --- | --- |
| `<leader><space>` | Find files from the project root |
| `<leader>/` | Search text across the project |
| `<leader>ff` | Find files from the project root |
| `<leader>fg` | Find files tracked by Git |
| `<leader>fr` | Open a recently used file |
| `<leader>,` | Switch between open buffers |
| `<leader>fc` | Find a Neovim configuration file |
| `<leader>sk` | Search keymaps |
| `<leader>:` | Search command history |

The picker is Snacks, not fzf. Inside a picker, type to filter, use `<C-j>` and
`<C-k>` to move, `<C-q>` to send selections to the quickfix list, and `<Esc>` to
close it.

### Files, buffers, and windows

| Shortcut | Use |
| --- | --- |
| `<leader>e` | Open Oil in the current directory |
| `<leader>bb` | Switch to the previous buffer |
| `<leader>bd` | Delete the current buffer without closing the layout |
| `<leader>bo` | Delete all other buffers |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<C-h/j/k/l>` | Move between splits |
| `<leader>\|` | Split vertically |
| `<leader>-` | Split horizontally |
| `<C-Left/Right>` | Resize the current split horizontally |
| `<C-Up/Down>` | Resize the current split vertically |

Inside Oil, use normal editing commands to rename, delete, create, or move
files, then save the Oil buffer to apply the batch of filesystem changes.

### Completion and editing

| Shortcut | Use |
| --- | --- |
| `<Tab>` | Select the next completion or move forward in a snippet |
| `<S-Tab>` | Select the previous completion or move backward in a snippet |
| `<CR>` | Accept the selected completion |
| `<C-s>` | Save the current file |
| `<A-j>` / `<A-k>` | Move the current line or selection down / up |
| `gcc` | Toggle a line comment |
| `gc` in Visual mode | Toggle comments on the selection |
| `<` / `>` in Visual mode | Indent and keep the selection active |
| `<leader>cf` | Format the current buffer or selection |
| `<leader>cr` | Rename the symbol under the cursor |

Completion is intentionally quiet: buffer suggestions start after three
characters and are limited/ranked below LSP suggestions.

### LSP, diagnostics, and code structure

| Shortcut | Use |
| --- | --- |
| `gd` | Go to definition |
| `gr` | Find references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Show hover documentation |
| `<leader>ca` | Code actions |
| `<leader>cd` | Show diagnostics for the current line |
| `[d` / `]d` | Previous / next diagnostic |
| `[e` / `]e` | Previous / next error |
| `[w` / `]w` | Previous / next warning |
| `<leader>ss` | Symbols in the current file |
| `<leader>sS` | Symbols across the workspace |
| `<leader>xx` | Toggle Trouble diagnostics |

When a language server is not responding, use `:LspInfo` to inspect attached
servers. Use `:Mason` to install or update tools managed by Mason.

### Git and project maintenance

| Shortcut | Use |
| --- | --- |
| `<leader>gg` | Open Lazygit at the repository root, when installed |
| `<leader>gL` | Browse Git history |
| `<leader>gf` | Browse history for the current file |
| `<leader>gb` | Show blame for the current line |
| `<leader>gB` | Open the current file or selection in the web Git browser |
| `]c` / `[c` | Next / previous Git hunk |
| `<leader>ghs` | Stage the current hunk |
| `<leader>ghr` | Reset the current hunk |
| `<leader>ghu` | Undo staging the current hunk |
| `<leader>ghp` | Preview the current hunk inline |
| `<leader>st` | Find TODO comments |
| `<leader>sr` | Search and replace across the project with Grug-Far |

### Display and session controls

| Shortcut | Use |
| --- | --- |
| `<leader>us` | Toggle spelling |
| `<leader>uw` | Toggle line wrapping |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uh` | Toggle LSP inlay hints |
| `<leader>uT` | Toggle Treesitter |
| `<leader>um` | Toggle rendered Markdown |
| `<leader>z` | Toggle Zen mode |
| `<leader>wm` | Toggle the current window's zoom |
| `<leader>n` | Show notification history |
| `<C-/>` | Toggle a terminal |
| `<leader>cp` | Toggle Markdown browser preview in a Markdown buffer |

Press `<leader>` and wait whenever you forget a shortcut. Which-Key groups
commands by purpose, so it is usually faster than searching documentation.

## Files

- **`private_init.lua`**: entrypoint that initializes `lazy.nvim` and loads
  LazyVim.
- **`private_lazyvim.json`**: enabled LazyVim extras.
- **`private_lazy-lock.json`**: exact plugin commits for reproducible installs.
- **`private_stylua.toml`**: Lua formatting rules.
- **`private_dot_neoconf.json`**: project-local LSP and formatting settings.
- **`lua/config/`**: core options, keymaps, autocmds, and Lazy setup.
- **`lua/plugins/`**: custom plugin specifications and LazyVim overrides.
