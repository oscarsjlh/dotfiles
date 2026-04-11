return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- Setup nvim-treesitter with install directory
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- Install parsers synchronously on first setup
		local parsers = {
			"bash",
			"go",
			"python",
			"dockerfile",
			"hcl",
			"html",
			"jq",
			"json",
			"yaml",
			"vim",
			"vimdoc",
			"lua",
		}

		-- Install parsers if not already installed
		for _, parser in ipairs(parsers) do
			local ok, has_parser = pcall(function()
				return vim.treesitter.language.get_lang(parser) ~= nil
			end)
			if not ok or not has_parser then
				require("nvim-treesitter").install({ parser })
			end
		end

		-- Enable treesitter highlighting via autocmd
		vim.api.nvim_create_autocmd("FileType", {
			pattern = parsers,
			callback = function(args)
				if vim.fn.exists("b:ts_highlight") == 0 then
					vim.treesitter.start(args.buf)
				end
			end,
		})

		-- Enable treesitter-based indentation
		vim.api.nvim_create_autocmd("FileType", {
			pattern = parsers,
			callback = function()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
