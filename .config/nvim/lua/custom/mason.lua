local lsp_zero = require('lsp-zero')
lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
    function(gopls)
      require('lspconfig')[gopls].setup({
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
            },

          }
        }
      })
    end,
    function (terraformls)
      require('lspconfig')[terraformls].setup{}
    end,
    function (yamlls)
     require('lspconfig')[yamlls].setup({
       settings {
         yaml = {
           schemaStore = {
             enable = false,
             url = "",
           },
           schemas = require("schemastore").yaml.schemas(),
       },
     }
     })
   end,
    lua_ls = function()
      -- (Optional) Configure lua language server for neovim
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})
