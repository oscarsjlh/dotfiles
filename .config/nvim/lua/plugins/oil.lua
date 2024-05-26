return {
	"stevearc/oil.nvim",
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			columns = { "icon" },
			keymaps = {
				["<C-h>"] = false,
				["<M-h>"] = "actions.select_split",
			},
			view_options = {
				show_hidden = true,
			},
		})

		vim.keymap.set("n", "e", "<CMD>Oil<CR>")
		-- Open parent directory in floating window
		-- vim.keymap.set("n", "e", require("oil").toggle_float)
	end,
}
