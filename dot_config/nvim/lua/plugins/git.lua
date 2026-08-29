-- pulled in from kunchenguid/dotfiles
-- git actions themselves stay in the terminal (lazygit/delta); this is just the inline gutter/blame
return {
  {
    -- LazyVim already ships gitsigns.nvim; this just adds current_line_blame on top
    "lewis6991/gitsigns.nvim",
    opts = { current_line_blame = true },
  },
}
