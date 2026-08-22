return {
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      set_dark_mode = function()
        vim.cmd.colorscheme("tokyonight-night")
      end,
      set_light_mode = function()
        vim.cmd.colorscheme("tokyonight-day")
      end,
      update_interval = 3000, -- check system appearance every 3 seconds
    },
  },
}
