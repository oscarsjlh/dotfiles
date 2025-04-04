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

function Create_tmux_split()
	FilePath = vim.api.nvim_buf_get_name(0)
	local trimmed = vim.fn.fnamemodify(FilePath, ":p:h")
	Command = "tmux split-window -c '" .. trimmed .. "'"
	os.execute(Command)
end

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

vim.lsp.enable("luals")
