-- [[ Configure and install plugins ]]
--  To check the current status of your plugins, run
--    :Lazy
--  You can press `?` in this menu for help. Use `:q` to close the window
--  To update plugins you can run
--    :Lazy update
require("lazy").setup({
	require("plugins.tokyonight"),
	require("plugins.gitsigns"),
	require("plugins.which-key"),
	require("plugins.telescope"),
	-- LSP Plugins --
	require("plugins.lazydev"),
	require("plugins.lsp_configuration"),
	require("plugins.autoformat"),
	require("plugins.autocompletion"),
	-- LSP Plugins --
	require("plugins.todo_comments"),
	require("plugins.mini"),
	require("plugins.nvim-treesitter"),
	--new plugins
	require("plugins.orgmode"),
	require("plugins.oil"),
	require("plugins.autopairs"),
	require("plugins.indent-blankline"),
	require("plugins.neo-tree"),
	require("plugins.vim-fugitive"),
	require("plugins.vim-surround"),
	require("plugins.harpoon"),
}, {
	git = {
		timeout = 300, -- kill processes that take more than 5 minutes
	},
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
		border = "rounded",
	},
})
