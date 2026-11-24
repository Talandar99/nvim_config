return {
	"nvim-flutter/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = true,
	opts = {
		lsp = { settings = { lineLength = 80 } },
	},
}
