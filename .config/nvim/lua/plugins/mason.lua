return {
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
}

-- return {
-- 	-- Snippets
-- 	{
-- 		"VonHeikemen/lsp-zero.nvim",
-- 		lazy = false,
-- 		-- priority = 100,
-- 		config = false,
-- 		init = function()
-- 			-- Disable automatic setup, we are doing it manually
-- 			vim.g.lsp_zero_extend_cmp = 0
-- 			vim.g.lsp_zero_extend_lspconfig = 0
-- 		end,
-- 	},
-- 	{
-- 		"williamboman/mason.nvim",
-- 		lazy = false,
-- 		config = true,
-- 	},
-- 	-- LSP
-- 	{
-- 		"neovim/nvim-lspconfig",
-- 		cmd = { "LspInfo", "LspInstall", "LspStart" },
-- 		event = { "BufReadPre", "BufNewFile" },
-- 		dependencies = {
-- 			{ "hrsh7th/cmp-nvim-lsp" },
-- 			{ "williamboman/mason-lspconfig.nvim" },
-- 			{ "b0o/SchemaStore.nvim" },
-- 		},
-- 		config = function()
-- 			local lsp_zero = require("lsp-zero")
-- 			lsp_zero.extend_lspconfig()
--
-- 			lsp_zero.on_attach(function(client, bufnr)
-- 				lsp_zero.default_keymaps({ buffer = bufnr })
-- 			end)
-- 			require("custom.mason")
-- 			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
-- 			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
-- 			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
-- 			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
-- 		end,
-- 	},
-- }
