return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	config = function()
		--resizing output window
		vim.api.nvim_create_autocmd({ "BufReadPost" }, {
			pattern = { "*.dbout" },
			callback = function()
				vim.api.nvim_exec2(
					[[
          exe ':resize 25'
          ]],
					{}
				)
			end,
		})
	end,
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
	end,
}
--    postgresql://postgres:secret@remote-host/test
--    mysql://root@localhost/test
--    sqlite:PATH_TO_FILE
--    mongodb:///admin
--    redis:///
