return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
	},
	config = function()
		local servers = {
			bashls = {},
			gopls = {},
			terraformls = {},
			dockerls = {},
			yamlls = {},
			jsonls = {},
			lua_ls = {},
		}
		local ensure_installed = vim.tbl_keys(servers or {})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = ensure_installed,
		})
		for server, settings in pairs(servers) do
			vim.lsp.config(server, settings)
			vim.lsp.enable(server)
		end
	end,
}
