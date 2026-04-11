return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			-- mini.pairs - Auto pairs (replaces nvim-autopairs)
			require("mini.pairs").setup({
				modes = { insert = true, command = true, terminal = false },
				skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
				skip_ts = { "string" },
				skip_unbalanced = true,
				markup = {
					equation = { "$$", "$$" },
					info = { "```", "```" },
					inline = { "`", "`" },
				},
			})

			-- mini.surround - Surround text objects (replaces nvim-surround)
			require("mini.surround").setup({
				highlight_duration = 500,
				n_mappings = {
					add = "gsa",
					delete = "gsd",
					find = "gsf",
					find_left = "gsF",
					highlight = "gsh",
					replace = "gsr",
					update_n_lines = "gsn",
				},
			})

			-- mini.statusline - Simple statusline (replaces lualine)
			require("mini.statusline").setup({
				content = {
					active = function()
						local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local git = MiniStatusline.section_git({ trunc_width = 75 })
						local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
						local filename = MiniStatusline.section_filename({ trunc_width = 140 })
						local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
						local location = MiniStatusline.section_location({ trunc_width = 75 })

						return MiniStatusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
							"%<",
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=",
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = mode_hl, strings = { location } },
						})
					end,
					inactive = nil,
				},
				set_vim_settings = true,
			})

			-- mini.diff - Git diff in gutter (replaces gitsigns)
			require("mini.diff").setup({
				source = require("mini.diff").gen_source.git(),
				view = {
					style = "sign",
					signs = {
						add = "▎",
						change = "▎",
						delete = "➤",
					},
				},
			})

			-- mini.ai - Better text objects
			require("mini.ai").setup({
				n_lines = 50,
				search_method = "cover_or_next",
				custom_textobjects = nil,
			})

			-- mini.move - Move lines with Alt+hjkl
			require("mini.move").setup({
				mappings = {
					left = "<M-h>",
					right = "<M-l>",
					down = "<M-j>",
					up = "<M-k>",
					line_left = "<M-h>",
					line_right = "<M-l>",
					line_down = "<M-j>",
					line_up = "<M-k>",
				},
			})

			-- mini.bufremove - Better buffer deletion
			require("mini.bufremove").setup({
				set_vim_settings = true,
			})

			-- Set up keymaps for bufremove
			vim.keymap.set("n", "<leader>bd", function()
				require("mini.bufremove").delete(0, false)
			end, { desc = "Delete buffer" })
			vim.keymap.set("n", "<leader>bD", function()
				require("mini.bufremove").delete(0, true)
			end, { desc = "Delete buffer (force)" })
		end,
	},
}
