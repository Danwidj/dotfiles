-- pulled in from kunchenguid/dotfiles
return {
  {
    -- edit a directory as a normal buffer: rename/delete/create by editing text and saving
    "stevearc/oil.nvim",
    opts = { view_options = { show_hidden = true } },
    keys = { { "<leader>e", "<cmd>Oil<cr>", desc = "File Browser" } },
  },
  {
    -- LazyVim already ships snacks.nvim; this just turns on the picker/notifier/input pieces
    "folke/snacks.nvim",
    opts = {
      picker = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },
    },
    -- no custom keys: LazyVim's own <leader>f*/<leader>s*/gd bindings already cover these
  },
}
