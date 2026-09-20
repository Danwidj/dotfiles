-- Shell (bash/sh) LSP via bash-language-server. No zsh support: bashls
-- parses with tree-sitter-bash and misreads zsh-only syntax, so it's left
-- unconfigured for .zsh files rather than attached with noisy diagnostics.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
}
