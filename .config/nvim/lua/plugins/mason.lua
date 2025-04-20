return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
	},
	config = function()
		local function get_python_path()
			local venv_path = vim.fn.getcwd() .. "/venv/bin/python"
			if vim.fn.executable(venv_path) == 1 then
				return venv_path
			else
				return "python" -- fallback
			end
		end
		local servers = {
			bashls = {},
			basedpyright = {},
			gopls = {},
			terraformls = {},
			dockerls = {},
			ruff = {
				settings = {},
				commands = {
					RuffAutofix = {
						function()
							Client:exec_cmd({
								command = "ruff.applyAutofix",
								arguments = {
									{ uri = vim.uri_from_bufnr(0) },
								},
							})
						end,
						description = "Ruff: Fix all auto-fixable problems",
					},
					RuffOrganizeImports = {
						function()
							Client:exec_cmd({
								command = "ruff.applyOrganizeImports",
								arguments = {
									{ uri = vim.uri_from_bufnr(0) },
								},
							})
						end,
						description = "Ruff: Format imports",
					},
				},
			},
			yamlls = {
				settings = {
					yaml = {
						validate = true,
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = {
							["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
							["https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json"] = "docker-compose*.{yml,yaml}",
							["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "argocd-application.yaml",
						},
					},
				},
			},
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
