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
