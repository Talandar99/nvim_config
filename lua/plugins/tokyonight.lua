return {
	-- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"folke/tokyonight.nvim",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme("tokyonight-night")

		-- You can configure highlights by doing something like:
		vim.cmd.hi("Comment gui=none")
		vim.cmd.hi("Folded guibg=none")

		--lsp windows borders
		--local _border = "single"
		local _border = "rounded"
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = _border,
		})
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = _border,
		})
		vim.diagnostic.config({
			float = { border = _border },
		})
	end,
	opts = {
		on_colors = function(colors)
			colors.border = "#565f89"
		end,
		transparent = true, -- Enable this to disable setting the background color
		lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
		transparent_sidebar = true,
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			--sidebars = "transparent",
			--floats = "transparent",
		},
	},
}
