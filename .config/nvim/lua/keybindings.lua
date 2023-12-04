vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.g.mapleader = ' '
vim.o.termguicolors = true
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"
vim.keymap.set({'n', 'x'}, 'cp', '"+y')
vim.keymap.set({'n', 'x'}, 'cv', '"+p')
vim.keymap.set({'n', 'x'}, 'x', '"_x')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", { silent = true })
vim.keymap.set("n", "<leader>gsy", "<cmd> GoTagAdd yaml <CR>", { silent = true })
vim.keymap.set("n", "<leader>gse", "<cmd> GoIfErr <CR>", { silent = true })
-- Map jj to save and exit insert mode
vim.keymap.set('i', 'jj', '<ESC>:wa<CR>', {noremap = true, silent = true})
-- Press i to enter insert mode, and ii to exit insert mode.

