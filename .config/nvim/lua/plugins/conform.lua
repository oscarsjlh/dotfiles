return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	-- Everything in opts will be passed to setup()
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			terraform = { "terraform_fmt" },
			tf = { "terraform_fmt" },
			["terraform-vars"] = { "terraform_fmt" },
			bash = { "shfmt" },
			sh = { "shfmt" },
			lua = { "stylua" },
			python = { "ruff_format", "ruff_format" },
			go = { "goimports", "gofmt" },
			javascript = { { "prettierd", "prettier" } },
			json = { "jq" },
			html = { { "prettier", "prettier" } },
		},
		-- Set up format-on-save
		format_on_save = { timeout_ms = 500, lsp_fallback = true },
		-- Customize formatters
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
