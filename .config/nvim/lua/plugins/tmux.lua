return {
	"aserowy/tmux.nvim",
	cond = function()
		return vim.env.HERDR_ENV ~= "1" and vim.env.TMUX ~= nil
	end,
	config = function()
		require("tmux").setup()
	end,
}
