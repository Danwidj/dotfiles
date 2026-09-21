-- Blink.cmp completion configuration
-- Combines super-tab navigation with noise-reduction for clean editing.
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
    },
    signature = {
      enabled = true,
    },
    sources = {
      min_keyword_length = 3,
      providers = {
        buffer = {
          min_keyword_length = 3,
          max_items = 5,
          score_offset = -3,
        },
        snippets = {
          min_keyword_length = 3,
        },
      },
    },
  },
}
