local null_ls = require("null-ls")
local opts = {
	null_ls.setup({
  sources = {
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.goimports_reviser,
    null_ls.builtins.formatting.golines,
		null_ls.builtins.formatting.terraform_fmt,
		null_ls.builtins.diagnostics.terraform_validate,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.prettier
   },
	})
}
return opts
