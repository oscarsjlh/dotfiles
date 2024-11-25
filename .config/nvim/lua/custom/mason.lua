local lsp_zero = require("lsp-zero")
lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
end)
require("mason-lspconfig").setup({
	ensure_installed = {},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
		function(gopls)
			require("lspconfig")[gopls].setup({
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
					},
				},
			})
		end,
		function(terraformls)
			require("lspconfig")[terraformls].setup({})
		end,
		function(emmet_language_server)
			require("lspconfig")[emmet_language_server].setup({
				settings = {
					filetypes = {
						"css",
						"eruby",
						"html",
						"javascript",
						"javascriptreact",
						"less",
						"sass",
						"scss",
						"pug",
						"typescriptreact",
					},
					init_options = {
						---@type table<string, string>
						includeLanguages = {},
						--- @type string[]
						excludeLanguages = {},
						--- @type string[]
						extensionsPath = {},
						--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
						preferences = {},
						--- @type boolean Defaults to `true`
						showAbbreviationSuggestions = true,
						--- @type "always" | "never" Defaults to `"always"`
						showExpandedAbbreviation = "always",
						--- @type boolean Defaults to `false`
						showSuggestionsAsSnippets = false,
						--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
						syntaxProfiles = {},
						--- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
						variables = {},
					},
				},
			})
		end,
		function(yamlls)
			require("lspconfig")[yamlls].setup({
				settings({
					yaml = {
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				}),
			})
		end,
		lua_ls = function()
			-- (Optional) Configure lua language server for neovim
			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
	},
})
