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
			language = true,
			disable_background = true,
			enabled = true,
			render_modes = true,
			sign = true,
			style = "language",
			position = "left",
			language_pad = 1,
			language_icon = true,
			language_name = true,
			highlight_border = false,
			above = "▄",
			below = "▀",
			left_margin = 0,
			left_pad = 0,
			right_pad = 0,
			min_width = 0,
			border = "thick",
			highlight = "RenderMarkdownCode",
			highlight_fallback = "RenderMarkdownCodeFallback",
			inline_pad = 0,
			highlight_inline = "RenderMarkdownCodeInline",
		},
	},
}
