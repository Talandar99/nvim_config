return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	config = function(_, opts)
		require("nvim-treesitter.query_predicates")
		require("vim.treesitter.query").add_directive("set-lang-from-info-string!", function(match, _, bufnr, predicate, metadata)
			local captured = match[predicate[2]]
			local node = type(captured) == "table" and captured[1] or captured
			if not node then
				return
			end

			local alias = vim.treesitter.get_node_text(node, bufnr):lower()
			local aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
			metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias }) or aliases[alias] or alias
		end, { force = true })
		require("render-markdown").setup(opts)
	end,
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
