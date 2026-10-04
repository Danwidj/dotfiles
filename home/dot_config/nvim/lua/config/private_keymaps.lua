-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Select all buffer with Cmd+A (<D-a>) in normal, visual, and insert modes
vim.keymap.set({ "n", "x" }, "<D-a>", "ggVG", { desc = "Select all" })
vim.keymap.set("i", "<D-a>", "<Esc>ggVG", { desc = "Select all" })

-- Keep clipboard intact: route deletes and changes to the black-hole register ("_)
-- Normal mode: deletes and changes do not alter clipboard
vim.keymap.set("n", "d", '"_d', { desc = "Delete (black hole)" })
vim.keymap.set("n", "D", '"_D', { desc = "Delete line to end (black hole)" })
vim.keymap.set("n", "c", '"_c', { desc = "Change (black hole)" })
vim.keymap.set("n", "C", '"_C', { desc = "Change line to end (black hole)" })
vim.keymap.set("n", "x", '"_x', { desc = "Delete char (black hole)" })
vim.keymap.set("n", "X", '"_X', { desc = "Delete char before (black hole)" })

-- Visual mode: deletes and changes do not alter clipboard
vim.keymap.set("x", "d", '"_d', { desc = "Delete selection (black hole)" })
vim.keymap.set("x", "D", '"_D', { desc = "Delete selection (black hole)" })
vim.keymap.set("x", "c", '"_c', { desc = "Change selection (black hole)" })
vim.keymap.set("x", "C", '"_C', { desc = "Change selection (black hole)" })
vim.keymap.set("x", "x", '"_x', { desc = "Delete selection (black hole)" })
vim.keymap.set("x", "X", '"_X', { desc = "Delete selection (black hole)" })

-- Visual mode paste over selection: preserve clipboard register (v_P behaviour)
vim.keymap.set("x", "p", "P", { desc = "Paste over selection without overwriting register" })
