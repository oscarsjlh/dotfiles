return {
	  'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},         -- Required
            {'hrsh7th/cmp-nvim-lsp'},     -- Required
            {'hrsh7th/cmp-buffer'},       -- Optional
            {'hrsh7th/cmp-path'},         -- Optional
            {'saadparwaiz1/cmp_luasnip'}, -- Optional
            {'hrsh7th/cmp-nvim-lua'},     -- Optional

            -- Snippets
            {'L3MON4D3/LuaSnip'},             -- Required
            {'rafamadriz/friendly-snippets'}, -- Optional
            {'jose-elias-alvarez/null-ls.nvim',
						opts = function ()
							return require "null-ls"
						end
					}, -- Optional
        },
				config = function()
					local lsp = require('lsp-zero')
					lsp.preset('recommended')
					require('lspconfig').gopls.setup({
						settings = {
							gopls = {
								completeUnimported = true,
								usePlaceholders = true,
								analyses = {
									unusedparams = true,
								},
						},
					}
				})
					require('lspconfig').yamlls.setup({
						schemaStore = {
							enable = true,
							url = "https://www.schemastore.org/api/json/catalog.json",
						},
						schemas = {
							kubernetes = "*.yaml",
							["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
							["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
							["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "azure-pipelines.yml",
							["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
							["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
							["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
							["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
							["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
							["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
							["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
							["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
							["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
							["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
						},
					})
					lsp.on_attach(function(client, bufnr)
						lsp.default_keymaps({buffer = bufnr})
					end)

					lsp.format_on_save({
						format_opts = {
							async = false,
							timeout_ms = 10000,
						},
						servers = {
							['null-ls'] = {'javascript', 'typescript', 'lua', 'go', "terraform", "sh", "css", "html", "yaml"},
						}
					})
					-- (Optional) Configure lua language server for neovim
					lsp.nvim_workspace()
					lsp.setup()
					local cmp = require('cmp')
					local cmp_action = require('lsp-zero').cmp_action()
					require('luasnip.loaders.from_vscode').lazy_load()
					cmp.setup({
						sources = {
							{name = 'nvim_lsp'},
              { name = "copilot", group_index = 2 },
							{name = 'luasnip'},
							{name = 'nvim_lua'},
							{name = 'path'},
						},
						mapping = {
							-- `Enter` key to confirm completion
							['<CR>'] = cmp.mapping.confirm({select = false}),

							-- Ctrl+Space to trigger completion menu
							['<C-Space>'] = cmp.mapping.complete(),

							-- Navigate between snippet placeholder
							['<C-f>'] = cmp_action.luasnip_jump_forward(),
							['<C-b>'] = cmp_action.luasnip_jump_backward(),
						}
})
	end
}
