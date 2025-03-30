require("mason").setup({})
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
		function(lua_ls)
			require("lspconfig")[lua_ls].setup({
				settings = {
					Lua = {
						telemetry = {
							enable = false,
						},
					},
				},
				on_init = function(client)
					local join = vim.fs.joinpath
					local path = client.workspace_folders[1].name

					-- Don't do anything if there is project local config
					if vim.uv.fs_stat(join(path, ".luarc.json")) or vim.uv.fs_stat(join(path, ".luarc.jsonc")) then
						return
					end

					-- Apply neovim specific settings
					local runtime_path = vim.split(package.path, ";")
					table.insert(runtime_path, join("lua", "?.lua"))
					table.insert(runtime_path, join("lua", "?", "init.lua"))

					local nvim_settings = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							version = "LuaJIT",
							path = runtime_path,
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
							library = {
								-- Make the server aware of Neovim runtime files
								vim.env.VIMRUNTIME,
								vim.fn.stdpath("config"),
							},
						},
					}

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, nvim_settings)
				end,
			})
		end,
	},
})
