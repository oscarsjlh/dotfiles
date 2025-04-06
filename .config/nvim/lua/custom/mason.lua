require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "gopls", "jsonls", "terraformls", "yamlls", "dockerls", "bashls" },
})
