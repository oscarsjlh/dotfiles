---@type vim.lsp.Config
return {
	filetypes = { "Dockerfile", "dockerfile" },
	cmd = { "docker-langserver", "--stdio" },
}
