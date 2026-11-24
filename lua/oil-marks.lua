local M = {}

local ns = vim.api.nvim_create_namespace("OilMarks")
local buffers = {}

local function entry_key(entry)
	return entry.id and ("id:" .. entry.id) or ("name:" .. entry.name)
end

local function state(bufnr)
	local dir = require("oil").get_current_dir(bufnr)
	local current = buffers[bufnr]
	if not current or current.dir ~= dir then
		if current then
			vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
		end
		current = { dir = dir, entries = {} }
		buffers[bufnr] = current
	end
	return current
end

function M.toggle()
	if vim.bo.filetype ~= "oil" then
		return
	end

	local entry = require("oil").get_cursor_entry()
	if not entry or not entry.name or entry.name == ".." then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local current = state(bufnr)
	local key = entry_key(entry)
	local marked = current.entries[key]

	if marked then
		vim.api.nvim_buf_del_extmark(bufnr, ns, marked.extmark)
		current.entries[key] = nil
		return
	end

	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local extmark = vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, 0, {
		virt_text = { { "M", "OilMark" } },
		virt_text_pos = "eol",
	})
	current.entries[key] = { name = entry.name, extmark = extmark }
end

function M.clear()
	if vim.bo.filetype ~= "oil" then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	buffers[bufnr] = nil
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

function M.get()
	if vim.bo.filetype ~= "oil" then
		return {}
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local current = state(bufnr)
	local oil = require("oil")
	local names = {}
	local seen = {}

	for line = 1, vim.api.nvim_buf_line_count(bufnr) do
		local entry = oil.get_entry_on_line(bufnr, line)
		if entry and entry.name and current.entries[entry_key(entry)] and not seen[entry.name] then
			seen[entry.name] = true
			names[#names + 1] = entry.name
		end
	end

	return names
end

vim.api.nvim_set_hl(0, "OilMark", { default = true, link = "DiagnosticWarn" })
vim.api.nvim_create_autocmd("BufWipeout", {
	group = vim.api.nvim_create_augroup("OilMarks", { clear = true }),
	callback = function(args)
		buffers[args.buf] = nil
	end,
})

return M
