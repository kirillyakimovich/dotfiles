vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
require("gitsigns").setup()

vim.keymap.set("n", "[g", "<cmd>Gitsigns nav_hunk prev<CR>")
vim.keymap.set("n", "]g", "<cmd>Gitsigns nav_hunk next<CR>")
vim.keymap.set({ "n", "x" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
vim.keymap.set({ "n", "x" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
