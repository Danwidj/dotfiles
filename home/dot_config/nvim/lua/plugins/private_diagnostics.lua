-- Diagnostics configuration for Neovim LSP.
-- Shows full multiline diagnostic messages on virtual lines under the current
-- line instead of truncating at the window edge. End-of-line virtual text is
-- hidden on the current line to avoid duplicating messages.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_lines = {
          current_line = true,
        },
        virtual_text = {
          current_line = false,
        },
      },
    },
  },
}
