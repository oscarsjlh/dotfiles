-- Multiple colorschemes available to switch between
-- Use :colorscheme <name> to switch
return {
	-- Catppuccin theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
	},

	-- One Dark theme
	{
		"navarasu/onedark.nvim",
		lazy = true,
	},

	-- Dracula theme
	{
		"Mofiqul/dracula.nvim",
		lazy = true,
	},

	-- Kanagawa theme
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
	},

	-- Nightfox theme (includes Nordfox, Carbonfox, etc.)
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
	},

	-- Nord theme
	{
		"shaunsingh/nord.nvim",
		lazy = true,
	},

	-- Vague theme (active/default)
	{
		"vague-theme/vague.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("vague")
		end,
	},

	-- Gruvbox Material theme
	{
		"sainnhe/gruvbox-material",
		lazy = true,
		config = function()
			vim.g.gruvbox_material_transparent_background = 1
			vim.g.gruvbox_material_foreground = "mix"
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.g.gruvbox_material_float_style = "bright"
			vim.g.gruvbox_material_statusline_style = "material"
			vim.g.gruvbox_material_cursor = "auto"
		end,
	},

	-- Everforest theme
	{
		"sainnhe/everforest",
		lazy = true,
	},

	-- Tokyo Night theme
	{
		"folke/tokyonight.nvim",
		lazy = true,
	},

	-- Solarized theme
	{
		"shaunsingh/solarized.nvim",
		lazy = true,
	},

	-- Rose Pine theme
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
	},

	-- Oxocarbon theme
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = true,
	},
}
