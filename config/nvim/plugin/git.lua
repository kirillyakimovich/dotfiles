vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
require("gitsigns").setup()

vim.keymap.set("n", "[c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    require("gitsigns").nav_hunk("prev")
  end
end)
vim.keymap.set("n", "]c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    require("gitsigns").nav_hunk("next")
  end
end)
vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>")
vim.keymap.set("n", "<leader>hb", "<cmd>Gitsigns blame_line full=true<CR>")
vim.keymap.set("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
vim.keymap.set({ "n", "x" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
vim.keymap.set({ "n", "x" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")

vim.api.nvim_create_user_command("Gqf", "silent cexpr system('git jump --stdout diff <args>') | copen", { nargs = "*" })
