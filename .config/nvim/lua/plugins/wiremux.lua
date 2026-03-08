return {
	"MSmaili/wiremux.nvim",
	dependencies = {
		-- Optional: nicer picker UI
		"ibhagwan/fzf-lua",
	},
	opts = {
		picker = { adapter = "fzf-lua" },
		targets = {
			definitions = {
				opencode = { cmd = "opencode", kind = { "pane", "window" }, split = "horizontal", shell = false },
				claude = { cmd = "claude", kind = "pane", split = "horizontal", shell = false },
				shell = { kind = "pane", split = "horizontal", shell = true },
				quick = { kind = { "window" }, shell = true, split = "horizontal" },
			},
		},
	},
	keys = {
		-- Toggle visibility of last used target
		{
			"<leader>aa",
			function()
				require("wiremux").toggle()
			end,
			desc = "Toggle target",
		},
		-- Create new target from definitions
		{
			"<leader>ac",
			function()
				require("wiremux").create()
			end,
			desc = "Create target",
		},
		-- Send file path
		{
			"<leader>af",
			function()
				require("wiremux").send("{file}", { focus = true })
			end,
			desc = "Send file",
		},
		-- Send "this" (position + selection in visual mode)
		{
			"<leader>at",
			function()
				require("wiremux").send("{this}", { focus = true })
			end,
			mode = { "x", "n" },
			desc = "Send this",
		},
		-- Send visual selection
		{
			"<leader>av",
			function()
				require("wiremux").send("{selection}", { focus = true })
			end,
			mode = { "x" },
			desc = "Send selection",
		},
		-- Send diagnostics
		{
			"<leader>ad",
			function()
				require("wiremux").send("{diagnostics}", { focus = true })
			end,
			desc = "Send line diagnostics",
		},
		{
			"<leader>aD",
			function()
				require("wiremux").send("{diagnostics_all}", { focus = true })
			end,
			desc = "Send all diagnostics on current buffer",
		},
		-- Send via motion (operator)
		{
			"ga",
			function()
				return require("wiremux").send_motion()
			end,
			mode = { "x", "n" },
			expr = true,
			desc = "Send motion",
		},
		{
			"<leader>ap",
			function()
				require("wiremux").send({
					-- AI Prompts
					{ label = "Review changes", value = "Can you review my changes?\n{changes}" },
					{
						label = "Fix diagnostics (file)",
						value = "Can you help me fix the diagnostics in {file}?\n{diagnostics_all}",
						visible = function()
							return require("wiremux.context").is_available("diagnostics_all")
						end,
					},
					{
						label = "Fix diagnostics (line)",
						value = "Can you help me fix this diagnostic?\n{diagnostics}",
						visible = function()
							return require("wiremux.context").is_available("diagnostics")
						end,
					},
					{ label = "Add docs", value = "Add documentation to {this}" },
					{ label = "Explain", value = "Explain {this}" },
					{ label = "Fix", value = "Can you fix {this}?" },
					{ label = "Optimize", value = "How can {this} be optimized?" },
					{ label = "Review file", value = "Can you review {file} for any issues?" },
					{ label = "Write tests", value = "Can you write tests for {this}?" },
					{
						label = "Fix quickfix",
						value = "Can you help me fix these issues?\n{quickfix}",
						visible = function()
							return require("wiremux.context").is_available("quickfix")
						end,
					},
				})
			end,
			mode = { "n", "x" },
			desc = "AI prompts",
		},
		-- Run project commands (context-aware)
		{
			"<leader>ar",
			function()
				require("wiremux").send({
					{
						label = "npm test",
						value = "npm test; exec $SHELL",
						submit = true,
						visible = function()
							return vim.fn.filereadable("package.json") == 1
						end,
					},
					{
						label = "npm run build",
						value = "npm run build",
						submit = true,
						visible = function()
							return vim.fn.filereadable("package.json") == 1
						end,
					},
					{
						label = "npm run start",
						value = "npm run start",
						submit = true,
						visible = function()
							return vim.fn.filereadable("package.json") == 1
						end,
					},
					{
						label = "go build",
						value = "go build",
						submit = true,
						visible = function()
							return vim.bo.filetype == "go"
						end,
					},
					{
						label = "go test (all)",
						value = "go test ./...",
						submit = true,
						visible = function()
							return vim.bo.filetype == "go"
						end,
					},
					{
						label = "make test",
						value = "make test",
						submit = true,
					},
					{
						label = "go test (selection)",
						value = "go test -run '{selection}'",
						submit = true,
						visible = function()
							return vim.bo.filetype == "go" and require("wiremux.context").is_available("selection")
						end,
					},
				}, {
					targets = "quick",
				}, {
					behavior = "last",
				})
			end,
			desc = "Run project command",
		},
	},
}
