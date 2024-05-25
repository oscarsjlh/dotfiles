vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append "c"

local lspkind = require "lspkind"
lspkind.init {}

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
require('luasnip.loaders.from_vscode').lazy_load()
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
    {name = 'nvim_lua'},
    {name = 'path'},
    {name = 'buffer'},
  },
  mapping = {
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})

