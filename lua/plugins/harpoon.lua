return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		--harpoon
		local harpoon = require("harpoon")
		-- REQUIRED
		harpoon:setup()
		-- REQUIRED

		vim.keymap.set("n", "<A-=>", function()
			harpoon:list():add()
		end, { noremap = true, desc = "Add file to harpoon list" })
		vim.keymap.set("n", "<A-->", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set("n", "<A-1>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<A-2>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<A-3>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<A-4>", function()
			harpoon:list():select(4)
		end)
		vim.keymap.set("n", "<A-5>", function()
			harpoon:list():select(4)
		end)
		vim.keymap.set("n", "<A-5>", function()
			harpoon:list():select(5)
		end)
		vim.keymap.set("n", "<A-6>", function()
			harpoon:list():select(6)
		end)
		vim.keymap.set("n", "<A-7>", function()
			harpoon:list():select(7)
		end)
		vim.keymap.set("n", "<A-8>", function()
			harpoon:list():select(8)
		end)
		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<A-S-P>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<A-S-N>", function()
			harpoon:list():next()
		end)
	end,
}
