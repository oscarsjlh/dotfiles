local TS = {
	"nvim-telescope/telescope-ui-select.nvim",
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}

function TS.config()
	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					additional_args = function()
						return { "--hidden", "--glob", "!**/.git/*" }
					end,
				},
				grep_string = {
					additional_args = function()
						return { "--hidden", "--glob", "!**/.git/*" }
					end,
				},
			},
		},
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({
					-- even more opts
				}),
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		},
	})
	require("telescope").load_extension("ui-select")
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>")
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
	vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
	vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>")
	vim.keymap.set("n", "<leader>y", "<cmd>Telescope yaml_schema<cr>")
end

return TS
