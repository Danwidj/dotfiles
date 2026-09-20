-- Python LSP via pyrefly (Meta's Rust-based type checker/LSP), instead of
-- LazyVim's default lang.python extra (pyright + ruff). nvim-lspconfig ships
-- a built-in `pyrefly` server config (cmd = { "pyrefly", "lsp" }) and Mason
-- has a "pyrefly" package, so it installs/updates the same way every other
-- server in this setup does.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyrefly = {},
      },
    },
  },
}
