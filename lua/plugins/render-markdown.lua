return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		render_modes = true,
		heading = {
			backgrounds = {},
			width = "block",
			left_pad = 0,
			position = "inline",
			sign = false,
			icons = {
				" ",
				"█ ",
				"██ ",
				"███ ",
				"████ ",
				"█████ ",
			},
		},
		code = {
			enabled = true,
			render_modes = false,
			sign = false,
			style = "language",
			position = "left",
			language_pad = 0,
			language_icon = true,
			language_name = true,
			disable_background = { "diff" },
			width = "block",
			left_margin = 0,
			left_pad = 0,
			right_pad = 0,
			min_width = 0,
			border = "none",
			above = " ",
			below = " ",
			highlight = "RenderMarkdownCode",
			highlight_language = nil,
			highlight_fallback = "RenderMarkdownCodeFallback",
			inline_pad = 0,
			highlight_inline = "RenderMarkdownCodeInline",
		},
	},
}
