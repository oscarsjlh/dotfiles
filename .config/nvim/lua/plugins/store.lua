return {
	"b0o/schemastore.nvim",
	"mosheavni/yaml-companion.nvim",
	requires = {
		{ "neovim/nvim-lspconfig" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" },
	},
	config = function()
		require("telescope").load_extension("yaml_schema")
	end,
}
