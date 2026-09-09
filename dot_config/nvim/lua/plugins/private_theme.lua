return {
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      set_dark_mode = function()
        vim.cmd.colorscheme("catppuccin-mocha")
      end,
      set_light_mode = function()
        vim.cmd.colorscheme("catppuccin-latte")
      end,
      update_interval = 3000,
    },
  },
}
