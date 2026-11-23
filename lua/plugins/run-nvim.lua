return {
	"guptaanurag2106/run.nvim",
	config = function()
		require("run").setup({
			-- File browser to use (default: "oil")
			current_browser = "oil",

			-- Ask for confirmation before executing commands
			ask_confirmation = true,

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
			focus_output = "never",

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
				-- Example: custom Python command
				--[".py"] = {
				--		command = "python %f",
				--		description = "Run Python module",
				--	},
				-- Add your own commands here
			},
			action_function = function(file_list, curr_dir)
				return "", false

				--				-- return <cmd>, <requires_completion>
				--				if #file_list == 1 and file_list[1] == "Makefile" then
				--					return "make -k", false
				--				end
				--
				--				local has_go_marker = false
				--				local only_go_project_files = #file_list > 0
				--				for _, file in ipairs(file_list) do
				--					if file == "go.mod" or file == "go.sum" then
				--						has_go_marker = true
				--					elseif not file:match("%.go$") then
				--						only_go_project_files = false
				--					end
				--				end
				--				if has_go_marker and only_go_project_files then
				--					return "go run .", false
				--				end
				--				return nil, false
			end,
		})
	end,
}
