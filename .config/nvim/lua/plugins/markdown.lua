return {
	"MeanderingProgrammer/render-markdown.nvim",
	after = { "nvim-treesitter" },
	requires = { "echasnovski/mini.icons", opt = true }, -- if you use standalone mini plugins
	-- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
	config = function()
		require("render-markdown").setup({
			completions = { blink = { enabled = true } },
			render_modes = { "n", "c", "t" },
		})
	end,
}
