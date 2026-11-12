vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
-- bin/git-review sets review.base in the worktree it creates, so signs show the
-- PR's changes. Only linked worktrees (.git is a file) can have it.
local root = vim.fs.root(vim.fn.getcwd(), ".git")
local linked = root and (vim.uv.fs_stat(root .. "/.git") or {}).type == "file"
local review = linked and vim.fn.system({ "git", "config", "--get", "review.base" })
require("gitsigns").setup({ base = review and vim.v.shell_error == 0 and vim.trim(review) or nil })

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
