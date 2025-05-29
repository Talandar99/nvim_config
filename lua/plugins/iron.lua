return {
	"hkupty/iron.nvim",
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")
		local common = require("iron.fts.common")

		iron.setup({
			config = {
				scratch_repl = true,
				repl_definition = {
					javascript = {
						command = { "mongosh" },
						block_dividers = { "// %%", "//%%" },
					},
					sh = {
						command = { "bash" },
					},
					python = {
						command = { "python3" },
						format = common.bracketed_paste_python,
						block_dividers = { "# %%", "#%%" },
					},
				},
				repl_filetype = function(bufnr, ft)
					return ft
				end,
				repl_open_cmd = view.right(80),
			},
			keymaps = {
				toggle_repl = "<space>ir",
				restart_repl = "<space>iR",
				send_motion = "<space>ic",
				visual_send = "<space>ic",
				send_file = "<space>if",
				send_line = "<space>il",
				send_paragraph = "<space>ip",
				send_until_cursor = "<space>iu",
				send_mark = "<space>im",
				send_code_block = "<space>ib",
				send_code_block_and_move = "<space>in",
				mark_motion = "<space>imc",
				mark_visual = "<space>imc",
				remove_mark = "<space>imd",
				cr = "<space>is<cr>",
				interrupt = "<space>is<space>",
				exit = "<space>isq",
				clear = "<space>i<cr>",
			},
			highlight = {
				italic = true,
			},
			ignore_blank_lines = true,
		})

		vim.keymap.set("n", "<space>if", "<cmd>IronFocus<cr>")
		vim.keymap.set("n", "<space>ih", "<cmd>IronHide<cr>")
	end,
}
