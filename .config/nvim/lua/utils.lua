vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
	callback = function(ev)
		vim.bo[ev.buf].commentstring = "# %s"
	end,
	pattern = { "terraform", "hcl", "terraform-vars" },
})

vim.filetype.add({
	pattern = {
		[".*/templates/.*%.yaml"] = "helm",
	},
})

function Create_terminal_split()
	local file_path = vim.api.nvim_buf_get_name(0)
	local directory = file_path ~= "" and vim.fn.fnamemodify(file_path, ":p:h") or vim.fn.getcwd()
	local command
	if vim.env.HERDR_ENV == "1" then
		command = { "herdr", "pane", "split", "--current", "--direction", "down", "--cwd", directory, "--focus" }
	elseif vim.env.TMUX then
		command = { "tmux", "split-window", "-c", directory }
	else
		vim.notify("Open Neovim inside herdr or tmux first", vim.log.levels.WARN)
		return
	end
	local result = vim.system(command, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify(result.stderr ~= "" and result.stderr or result.stdout, vim.log.levels.ERROR)
	end
end

vim.keymap.set("n", "<leader>r", function()
	vim.cmd("w")
	vim.cmd("belowright split | terminal bash %")
end, { desc = "Run current script" })

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "css,eruby,html,htmldjango,javascriptreact,javascript,less,pug,sass,scss,typescriptreact",
	callback = function()
		vim.lsp.start({
			name = "emmet",
			cmd = { "emmet-language-server", "--stdio" },
			root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
			-- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
			-- **Note:** only the options listed in the table are supported.
			init_options = {
				---@type table<string, string>
				includeLanguages = {},
				--- @type string[]
				excludeLanguages = {},
				--- @type string[]
				extensionsPath = {},
				--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
				preferences = {},
				--- @type boolean Defaults to `true`
				showAbbreviationSuggestions = true,
				--- @type "always" | "never" Defaults to `"always"`
				showExpandedAbbreviation = "always",
				--- @type boolean Defaults to `false`
				showSuggestionsAsSnippets = false,
				--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
				syntaxProfiles = {},
				--- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
				variables = {},
			},
		})
	end,
})

-- Note: lua_ls is configured in mason.lua, no need to enable here
