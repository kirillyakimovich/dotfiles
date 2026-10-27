vim.o.exrc = true

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftround = true

vim.o.number = true
vim.o.winborder = "rounded"

-- Color Scheme
--
-- Old Solarized needs 256-color mode
vim.o.termguicolors = false
vim.o.background = "light"
vim.g.solarized_diffmode = "high"
vim.cmd.colorscheme("solarized")
