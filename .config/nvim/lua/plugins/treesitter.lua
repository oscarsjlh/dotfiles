return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
	require('nvim-treesitter.configs').setup({
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
				}
			},
  },
		ensure_installed = {
			"bash",
			"go",
			"python",
			"dockerfile",
			"hcl",
			"html",
			"jq",
			"json",
			"yaml",
			"vim",
			"vimdoc",
			"lua",
		},
		auto_install = true,
	})
end
}
