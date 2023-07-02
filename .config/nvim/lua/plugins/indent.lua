return {
	"lukas-reineke/indent-blankline.nvim",
	config = function()

		require("indent_blankline").setup({
			char = "|",
			show_trailing_blankline_indent = false,
			show_first_indent_level = false,
			use_treesitter = true,
			show_end_of_line = true,
			show_current_context = false
		})
end
}
