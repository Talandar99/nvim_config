return {
	"guptaanurag2106/run.nvim",
	config = function()
		require("run").setup({
			-- File browser to use (default: "oil")
			current_browser = "oil",

			-- Ask for confirmation before executing commands
			ask_confirmation = false,

			-- Use custom input UI instead of vim.ui.input
			--use_custom_ui = true,
			use_custom_ui = false,

			-- open_cmd, default is auto-detected based on OS
			open_cmd = nil,

			-- Auto-populate quickfix list with command output for sync commands
			populate_qflist_sync = false,
			-- Auto-populate quickfix list with command output for async commands
			populate_qflist_async = true,

			-- Auto-open quickfix list with command output for sync commands
			open_qflist_sync = false,
			-- Auto-open quickfix list with command output for async commands
			open_qflist_async = false,

			-- Focus output window after run: "never" | "on_error" | "always"
			focus_output = "always",

			-- Highlight full stderr lines red in the output buffer (default: false)
			-- When false, only the matched file:line:col span is highlighted.
			highlight_stderr_full = false,

			-- Enable command history
			history = {
				enable = false,
				history_file = vim.fn.stdpath("data") .. require("run.utils").path_separator .. "run.nvim.json",
			},

			-- UI settings for custom input window
			--ui = {
			--	border = "none",
			--	prompt_hl = "Constant",
			--},
			ui = {
				border = "rounded",
				prompt_hl = "Constant",
			},

			-- Command to open the output window
			output_window_cmd = "botright 15split",

			-- Fallback cwd scope when browser cwd lookup fails
			-- "global": use Neovim cwd (vim.fn.getcwd())
			-- "buffer": use current file directory for normal file buffers
			cwd_fallback_scope = "global",

			-- Customize default actions for specific file types
			default_actions = {
				[".tar.xz"] = {
					command = "tar xJvf %1 -C %d",
					description = "Extracts xz archive",
				},
				dir = {
					command = "tar cJvf %1.tar.xz -C %d %f",
					description = "Creates xz archive",
				},
				multiple = {
					command = "tar cJvf %1.tar.xz -C %d %f",
					description = "Creates xz archive",
				},
			},
			action_function = function(file_list, _curr_dir)
				local marked = require("oil-marks").get()
				if #marked == 0 then
					return
				end

				local selected = {}
				for _, name in ipairs(file_list) do
					selected[name] = true
				end
				for _, name in ipairs(marked) do
					selected[name] = true
				end

				local oil = require("oil")
				local bufnr = vim.api.nvim_get_current_buf()
				local merged = {}
				local seen = {}
				for line = 1, vim.api.nvim_buf_line_count(bufnr) do
					local entry = oil.get_entry_on_line(bufnr, line)
					if entry and entry.name and selected[entry.name] and not seen[entry.name] then
						seen[entry.name] = true
						merged[#merged + 1] = entry.name
					end
				end

				for i = #file_list, 1, -1 do
					file_list[i] = nil
				end
				for i, name in ipairs(merged) do
					file_list[i] = name
				end
			end,
		})
	end,
}
