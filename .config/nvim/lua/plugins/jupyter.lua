return {
	{
		"goerz/jupytext.nvim",
		version = "0.2.0",
		lazy = false,
		opts = {
			jupytext = vim.fn.stdpath("config") .. "/bin/jupytext",
			format = "md:markdown",
			update = true,
			filetype = "markdown",
			autosync = true,
		},
	},
}
