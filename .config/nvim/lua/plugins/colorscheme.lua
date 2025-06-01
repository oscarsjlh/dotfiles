return {
	"catppuccin/nvim",
	"navarasu/onedark.nvim",
	"Mofiqul/dracula.nvim",
	"rebelot/kanagawa.nvim",
	"EdenEast/nightfox.nvim",
	"shaunsingh/nord.nvim",
	"sainnhe/gruvbox-material",
	enabled = true,
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_transparent_background = 1
		vim.g.gruvbox_material_foreground = "mix"
		vim.g.gruvbox_material_background = "hard"
		vim.g.gruvbox_material_ui_contrast = "high"
		vim.g.gruvbox_material_float_style = "bright"
		vim.g.gruvbox_material_statusline_style = "material"
		vim.g.gruvbox_material_cursor = "auto"
		vim.cmd.colorscheme("gruvbox-material")
	end,
	"sainnhe/everforest",
	"navarasu/onedark.nvim",
	"folke/tokyonight.nvim",
	"shaunsingh/solarized.nvim",
	"rose-pine/neovim",
	name = "rose-pine",
	"nyoom-engineering/oxocarbon.nvim",
}
