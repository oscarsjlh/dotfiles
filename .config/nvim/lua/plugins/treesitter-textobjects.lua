return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	-- The main branch has a simplified API
	-- Text objects are automatically available via queries
	-- No complex setup needed anymore
}
