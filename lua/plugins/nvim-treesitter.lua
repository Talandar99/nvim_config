local parsers = {
	"bash",
	"c",
	"diff",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
	"json",
	"yaml",
	"python",
	"make",
	"typescript",
	"nginx",
	"sql",
	"java",
	"dart",
	"rust",
	"ruby",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.setup()
		treesitter.install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = parsers,
			callback = function(event)
				local language = vim.treesitter.language.get_lang(event.match)
				if not language then
					return
				end

				local ok, parser = pcall(vim.treesitter.get_parser, event.buf, language)
				if not ok or not parser then
					return
				end

				vim.treesitter.start(event.buf, language)
				if event.match ~= "ruby" then
					vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
