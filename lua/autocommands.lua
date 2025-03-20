-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

--automaticly add debuger shortkey if file is rust file
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.rs",
	callback = function()
		vim.keymap.set("n", "<F5>", "<cmd>RustDebuggables<CR>")
	end,
})
--automaticly add debuger shortkey if file is python file
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.py",
	callback = function()
		vim.keymap.set("n", "<F5>", function()
			require("dap").continue()
		end)
	end,
})

--automaticly disable indent_blankline if .org
--automaticly enable conceallevel if .org
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.org",
	callback = function()
		vim.api.nvim_command("set nofoldenable")
		vim.api.nvim_command("IBLDisable")
		vim.opt.conceallevel = 2
	end,
})

--automaticly enable conceallevel if .md
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.md",
	callback = function()
		vim.opt.conceallevel = 2
	end,
})
--custom highlight for zenscript
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.zs",
	callback = function()
		vim.api.nvim_command("set filetype=ts")
	end,
})
--automaticly format file using ClangFormat if it's C file
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.c",
	callback = function()
		vim.api.nvim_command("ClangFormat")
	end,
})

--if file is sqlite database connect to it
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.sqlite",
	callback = function()
		if vim.g.dbs == nil then
			local buff_name = vim.api.nvim_buf_get_name(0)
			local path = "sqlite:" .. buff_name
			vim.g.dbs = {
				{
					name = path,
					url = function()
						return path
					end,
				},
			}
			vim.api.nvim_command("DBUIFindBuffer")
			local window_id = vim.api.nvim_get_current_win()
			vim.api.nvim_win_close(window_id, true)
			--vim.api.nvim_command("bd#")
		else
			--vim.api.nvim_command("DBUI")
		end
	end,
})
--don't conceallevel json
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.json",
	callback = function()
		vim.api.nvim_command("set conceallevel=0")
	end,
})
--add soil autocommand when editing plantuml
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.plantuml",
	callback = function()
		vim.keymap.set({ "n", "x" }, "<leader>cs", "<cmd>Soil<CR>", { noremap = true, desc = "[C]ode run [S]oil" })
	end,
})
