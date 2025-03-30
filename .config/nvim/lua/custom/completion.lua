vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "buffer" },
	},
	mapping = cmp.mapping.preset.insert({
		-- `Enter` key to confirm completion
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

		-- Ctrl+Space to trigger completion menu
		["<C-Space>"] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		-- ['<C-f>'] = cmp_action.luasnip_jump_forward(),
		-- ['<C-b>'] = cmp_action.luasnip_jump_backward(),
	}),
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
			vim.snippet.expand(args.body)
		end,
	},
})
