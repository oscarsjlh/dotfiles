return {
	'nvim-lualine/lualine.nvim',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
	require('lualine').setup({
		component_separators = '|',
		section_separators = '',
		path = 2,
	})
end
}
