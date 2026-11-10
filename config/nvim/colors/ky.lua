vim.g.solarized_diffmode = "high"
vim.cmd.runtime("colors/solarized.vim")
vim.g.colors_name = "ky"

vim.api.nvim_set_hl(0, "Pmenu", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "PmenuBorder", { link = "FloatBorder" })
