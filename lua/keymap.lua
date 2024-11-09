-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- vim.api.nvim_del_keymap("n", "<C-l>")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { noremap = true, desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { noremap = true, desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { noremap = true, desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { noremap = true, desc = "Move focus to the upper window" })

-- my keymaps
-- open oil with -
vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
-- automatically center after C-d C-u
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
-- exit
vim.keymap.set("n", "<leader>q", "<cmd>:q<CR>", { noremap = true, desc = "quit focused element" })
-- open_configs
vim.keymap.set("n", "<leader>|", "<cmd>:e ~/.config/nvim<CR>", { noremap = true, desc = "Open Neovim Configuration" })
-- open notes
vim.keymap.set("n", "<leader>on", "<cmd>:e ~/workspace/notes<CR>", { noremap = true, desc = "orgmode notes" })
-- open vim fugitive
vim.keymap.set("n", "<leader>gg", "<cmd>:0G<CR>", { noremap = true, desc = "[G]it Menu" })
vim.keymap.set("n", "<leader>gl", "<cmd>:Git pull<CR>", { noremap = true, desc = "[G]it Pu[l]l" })
vim.keymap.set("n", "<leader>gs", "<cmd>:Git push<CR>", { noremap = true, desc = "[G]it Pu[s]h" })
vim.keymap.set("n", "<leader>gf", "<cmd>:Git fetch<CR>", { noremap = true, desc = "[G]it [f]etch" })
