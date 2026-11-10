vim.o.exrc = true

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftround = true

vim.o.foldmethod = "indent"
vim.o.foldenable = false
vim.o.foldlevel = 99

vim.o.linebreak = true
vim.o.breakindent = true
vim.o.breakindentopt = "shift:2"

vim.o.number = true
vim.o.winborder = "rounded"

-- Color Scheme
--
-- Old Solarized needs 256-color mode
vim.o.termguicolors = false
vim.o.background = "light"
vim.cmd.colorscheme("ky")
